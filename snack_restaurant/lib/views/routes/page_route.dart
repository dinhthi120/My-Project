import 'package:snack_restaurant/views/fragments/auth/change_password.dart';
import 'package:snack_restaurant/views/fragments/auth/edit_profile.dart';
import 'package:snack_restaurant/views/fragments/my_order.dart';
import 'package:snack_restaurant/views/fragments/checkout.dart';
import 'package:snack_restaurant/views/fragments/home_page.dart';
import 'package:snack_restaurant/views/fragments/admin/item_page.dart';
import 'package:snack_restaurant/views/fragments/auth/login_page.dart';
import 'package:snack_restaurant/views/fragments/admin/order_page.dart';
import 'package:snack_restaurant/views/fragments/auth/signup_page.dart';

class PageRoutes {
  static const String home = HomePage.routeName;
  static const String item = ItemPage.routeName;
  static const String order = OrderPage.routeName;
  static const String login = LoginPage.routeName;
  static const String signUp = SignUpPage.routeName;
  static const String editProfile = EditProfile.routeName;
  static const String changePassword = ChangePassword.routeName;
  static const String checkOut = Checkout.routeName;
  static const String userOrders = UserOrders.routeName;
}

