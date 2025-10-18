import express from "express";
import cors from "cors";
import tripRoutes from "./routes/trip.js";

const app = express();
app.use(cors());
app.use(express.json());

app.use("/api/trip", tripRoutes);

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`🚀 TripMitra Backend running on port ${PORT}`));
