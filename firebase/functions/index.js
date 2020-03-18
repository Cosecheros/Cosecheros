const functions = require('firebase-functions');
const path = require('path');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((request, response) => {
	response.send("Hello from Firebase!");
});

const admin = require('firebase-admin');
admin.initializeApp();

// Tal vez haya que usar admin acá
// https://stackoverflow.com/questions/42956250/get-download-url-from-file-uploaded-with-cloud-functions-for-firebase
// getDownloadURL al thumb en el que estamos, tal vez sea posible en un futuro
// https://github.com/firebase/extensions/issues/34

// object.name = cosechas/thumbs/idsha-granizo_500x500.jpg
// object.name = cosechas/thumbs/idsha-granizada_500x500.jpg
exports.thumbReady = functions.storage.bucket()
	.object().onFinalize(async (object) => {
		if (!object.name.startsWith('cosechas/thumbs/')) {
			console.log('This is not in the thumbs directory.');
			return null;
		}

		const name = path.parse(object.name).name;
		const id = name.split('-')[0];
		const type = name.split('-')[1].split('_')[0];

		console.log(`Updated ${type} of ${id}`);
		return admin.firestore().doc(`cosechas/${id}`).update({ [`${type}_thumb`]: 'ready' });
	});
