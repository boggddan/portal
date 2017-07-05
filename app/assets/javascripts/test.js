const disabledFact = false;
const disabledPlan = true;
const isCheck = true;
const countPlan = 0;
const dataId = 10;

const result = (!disabledPlan || !isCheck || !countPlan) && !disabledFact && dataId;


console.log( Boolean(result) );
