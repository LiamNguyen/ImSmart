var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

var deviceList = [];

app.get('/', function(req, res){
  res.send('<h1>Socket is running</h1>');
})

http.listen(1208, function(){
  console.log('Listening on *:1208\n');
});

io.on('connection', function(clientSocket){
  console.log('A user has connected\n');

  clientSocket.on('disconnect', function(){
    console.log('A user has disconnected\n');
  });

  clientSocket.on('registerDevice', function(deviceUUID, deviceName) { 
  	console.log('Connected Device: ' + deviceName + '\n');

  	var isDeviceExist = false;

	for (var i = 0; i < deviceList.length; i++) {
		var device = deviceList[i];

		if (device.uuid === deviceUUID) {
	  		activateDevice(deviceUUID);
	  		isDeviceExist = true;
			break;
		}
	}

  	if (!isDeviceExist) {
	  	deviceList.push({
	  		'uuid'	: deviceUUID,
	  		'name'  : deviceName,
	  		'active': true
	  	});  
  	}

  	printDeviceList();

  	clientSocket.emit('confirmRegistered', 'Welcome ' + deviceName);
  	clientSocket.broadcast.emit('notifyOthersWhenConnected', deviceName + ' has join our system');
  });

  clientSocket.on('resignActive', function(deviceUUID) {
	for (var i = 0; i < deviceList.length; i++) {
		var device = deviceList[i];

		if (device.uuid === deviceUUID) {
	  		deactivateDevice(deviceUUID);
  		  	console.log('Resign Active Device: ' + device.deviceName);
			break;
		}
	}

  	printDeviceList();
  });

  clientSocket.on('requireUpdateLights', function() {
  	console.log('LIGHT UPDATE REQUIRED');

  	clientSocket.broadcast.emit('notifyOthersForLightsUpdate');
  });

});

checkDeviceExist = (deviceUUID, isDeviceExist) => {
	if (deviceList.length < 1) {
		isDeviceExist = false;
		return;
	}

	for (var i = 0; i < deviceList.length; i++) {
		var device = deviceList[i];
		if (device.uuid === deviceUUID) {
			isDeviceExist = true;
			break;
		}
	}
}

activateDevice = (deviceUUID) => {
	deviceList.forEach( device  => {
		if (device.uuid === deviceUUID) {
			device.active = true;
			return;
		}
	});
}

deactivateDevice = (deviceUUID) => {
	deviceList.forEach( device => {
		if (device.uuid === deviceUUID) {	
			device.active = false;
			return;
		}
	});
}

printDeviceList = () => {
	console.log('*****Device list*****\n')
	deviceList.map( (device, index) => {
		console.log('#' + (index + 1));
		console.log('Device UUID   : ' + device.uuid);
		console.log('Device name   : ' + device.name);
		console.log('Device status : ' + (device.active ? 'active' : 'inactive'));
		console.log('___________');
	});
	console.log('Number of devices: ' + deviceList.length + '\n');
}
