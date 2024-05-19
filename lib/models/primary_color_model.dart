import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class PrimaryColorModel extends Model {
  Color _primaryColor;

  PrimaryColorModel(this._primaryColor);

  Color get primaryColor => _primaryColor;

  void updatePrimaryColor(Color color) {
    _primaryColor = color;
    notifyListeners();
  }

  static PrimaryColorModel of(BuildContext context) =>
      ScopedModel.of<PrimaryColorModel>(context);
}