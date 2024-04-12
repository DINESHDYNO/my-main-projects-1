const express = require('express');
const bodyParser = require('body-parser');
const agora = require('agora-access-token');

const app = express();
app.use(bodyParser.json());

app.post('/generateToken', (req, res) => {
  const { uid, channelName } = req.body;
  const appID = 'your_app_id';
  const appCertificate = 'your_app_certificate';

  const agoraToken = agora.RtcTokenBuilder.buildTokenWithUid(
    appID,
    appCertificate,
    channelName,
    uid,
    agora.RtcRole.PUBLISHER,
    3600 // Token expiration time in seconds
  );

  res.json({ token: agoraToken });
});

app.listen(3000, () => {
  console.log('Server is running on port 3000');
});
