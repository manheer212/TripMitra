export function generateBudget(budgetType, days, people, domestic) {
  const base = budgetType === "Low" ? 1000 : budgetType === "Mid" ? 2500 : 6000;
  const transport = domestic ? 500 : 2000;
  const total = (base * days + transport) * people;

  return {
    budgetType,
    days,
    people,
    domestic,
    total,
    currency: "INR"
  };
}
