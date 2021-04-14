import 'package:expression_language/expression_language.dart';

class ToUpperCaseExpression extends Expression<String> {
  final Expression<String> value;

  ToUpperCaseExpression(this.value);

  @override
  Expression<String> clone(Map<String, ExpressionProviderElement> elementMap) {
    return ToUpperCaseExpression(value.clone(elementMap));
  }

  @override
  String evaluate() {
    return value.evaluate().toUpperCase();
  }

  @override
  List<Expression> getChildren() {
    return [
      value,
    ];
  }

  static ExplicitFunctionExpressionFactory get() {
    return ExplicitFunctionExpressionFactory(
      name: 'toUpperCase',
      parametersLength: 1,
      createFunctionExpression: (parameters) =>
          ToUpperCaseExpression(parameters[0] as Expression<String>),
    );
  }
}
