import express from "express";
import { Request, Response } from "express";

const app = express();

const PORT = process.env.PORT || 3000;

app.get("/", (req: Request, res: Response) => {
  res.json({
    message: "Hello from a container!",
    service: "hello-node",
    pod: process.env.POD_NAME || "unknown",
    time: new Date().toISOString(),
  });
});

app.get("/readyz", (req: Request, res: Response) => {
  res.status(200).send("ready");
});

app.get("/healthz", (req: Request, res: Response) => {
  res.status(200).send("healthy");
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
