(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['showtimes.tmpl'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = "", stack1, foundHelper, tmp1, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression, blockHelperMissing=helpers.blockHelperMissing;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n\n    <div class=\"listing\">\n\n      <li class=\"theater\">";
  foundHelper = helpers.information;
  stack1 = foundHelper || depth0.information;
  stack1 = (stack1 === null || stack1 === undefined || stack1 === false ? stack1 : stack1.name);
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "information.name", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</li>\n\n      <ul class=\"times\">\n        ";
  foundHelper = helpers.showtimes;
  stack1 = foundHelper || depth0.showtimes;
  tmp1 = self.program(2, program2, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.noop;
  if(foundHelper && typeof stack1 === functionType) { stack1 = stack1.call(depth0, tmp1); }
  else { stack1 = blockHelperMissing.call(depth0, stack1, tmp1); }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n      </ul>\n\n    </div>\n\n    ";
  return buffer;}
function program2(depth0,data) {
  
  var buffer = "", stack1, stack2;
  buffer += "\n        \n        ";
  foundHelper = helpers.url;
  stack1 = foundHelper || depth0.url;
  stack2 = helpers['if'];
  tmp1 = self.program(3, program3, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.program(5, program5, data);
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n\n        ";
  return buffer;}
function program3(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n\n          <li><a href=\"";
  foundHelper = helpers.url;
  stack1 = foundHelper || depth0.url;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "url", { hash: {} }); }
  buffer += escapeExpression(stack1) + "\">";
  foundHelper = helpers.time;
  stack1 = foundHelper || depth0.time;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "time", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</a></li>\n\n        ";
  return buffer;}

function program5(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n\n          <li>";
  foundHelper = helpers.time;
  stack1 = foundHelper || depth0.time;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "time", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</li>\n\n        ";
  return buffer;}

  buffer += "<ul>\n    ";
  foundHelper = helpers.theaters;
  stack1 = foundHelper || depth0.theaters;
  tmp1 = self.program(1, program1, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.noop;
  if(foundHelper && typeof stack1 === functionType) { stack1 = stack1.call(depth0, tmp1); }
  else { stack1 = blockHelperMissing.call(depth0, stack1, tmp1); }
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n</ul>\n";
  return buffer;});
})();