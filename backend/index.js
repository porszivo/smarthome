const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const Fritz = require('fritzapi').Fritz;

const user = '<InsertUsername>';
const passwort = '<InsertPassword>';
const url = 'http://fritz.box';

const f = new Fritz(user, passwort, url);

const devices = [];

app.use(bodyParser.json());

setInterval(async () => {
	for (const device of devices) {
		await f.getTemperature(device.id).then(roomTemp => {
			device.tempHistory.push({timestamp: Date.now(), roomTemp});
			device.roomTemp = roomTemp;
		});
		await f.getTempTarget(device.id).then(tempTarget => device.tempTarget = tempTarget);
		await f.getBatteryCharge(device.id).then(batteryCharge => device.batteryCharge = batteryCharge);
		await f.getSwitchName(device.id).then(name => device.name = name);
	}
}, 50000)

app.get('/devices', (req, res, next) => {
	res.json(devices);
})

app.put('/devices/:id', (req, res, next) => {
	const device = devices.find(a => a.id === req.params.id);
	if(device === undefined) {
		res.sendStatus(404);
	} else {
		const newTemp = req.body.targetTemp < 8
				? 'off'
				: (req.body.targetTemp > 28 ? 'on' : req.body.targetTemp);
		f.setTempTarget(device.id, newTemp);
		res.sendStatus(200);
	}
});

async function initDevices() {
	f.getThermostatList().then(a => {
		a.map(
				async thermostat => {
					const roomTemp = await f.getTemperature(thermostat);
					const tempTarget = await f.getTempTarget(thermostat);
					const batteryCharge = await f.getBatteryCharge(thermostat);
					const name = await f.getSwitchName(thermostat);
					devices.push({id: thermostat, name, roomTemp, tempTarget, batteryCharge, tempHistory: [{timestamp: Date.now(), roomTemp}]})
				}
		)
	});
}

app.listen(3000, async () => {
	console.log('Server is running on port 3000');
	await initDevices();
});
