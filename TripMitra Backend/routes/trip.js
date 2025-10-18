import express from "express";
import { generateBudget } from "../services/budgetService.js";

const router = express.Router();

router.post("/budget", (req, res) => {
  const { budgetType, days, people, domestic } = req.body;
  const result = generateBudget(budgetType, days, people, domestic);
  res.json(result);
});

export default router;
