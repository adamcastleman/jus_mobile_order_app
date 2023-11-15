module.exports = function isAuthenticated(context) {
  return context.auth && context.auth.uid !== null;
};
