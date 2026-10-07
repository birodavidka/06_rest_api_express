import {createApp} from './app'
import { getPort } from './config/env'

const app = createApp();
const port = getPort();

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});