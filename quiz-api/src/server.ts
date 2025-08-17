import { createApp } from "./app";
import { env } from "./config/env";

const app = createApp();
app.listen(env.PORT, () => {
  console.log(`Quiz API listening on http://127.0.0.1:${env.PORT}`);
});
