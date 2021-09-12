const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const settings = require('./config');
const Fritz = require('fritzapi').Fritz;

const user = settings.fritzbox.username;
const passwort = settings.fritzbox.password;
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
		await f.getTempTarget(device.id).then(
				tempTarget => device.tempTarget = tempTarget);
		await f.getBatteryCharge(device.id).then(
				batteryCharge => device.batteryCharge = batteryCharge);
		await f.getSwitchName(device.id).then(name => device.name = name);
	}
}, 10000)

app.get('/devices', (req, res, next) => {
	res.json(devices);
})

app.put('/devices/:id', (req, res, next) => {
	console.log(req.params.id);
	console.log(devices);
	const device = devices.find(a => a.id === req.params.id);
	if (device === undefined) {
		res.sendStatus(404);
	} else {
		console.log(req.params.id + " " + req.body.targetTemp);
		const targetTemp = req.body.targetTemp;
		f.setTempTarget(device.id, targetTemp);
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
					devices.push({
						id: thermostat,
						name,
						roomTemp,
						tempTarget,
						type: 'thermometer',
						batteryCharge,
						tempHistory: [{timestamp: Date.now(), roomTemp}]
					})
				}
		)
	});
}

app.listen(3000, async () => {
	console.log('Server is running on port 3000');
	await initDevices();
});
