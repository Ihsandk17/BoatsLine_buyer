import 'package:boats_line/consts/consts.dart';
import 'package:boats_line/consts/lists.dart';
import 'package:boats_line/controllers/auth_controller.dart';
import 'package:boats_line/views/auth_screen/signup_screen.dart';
import 'package:boats_line/widgets_common/applogo_widget.dart';
import 'package:boats_line/widgets_common/bg_widget.dart';
import 'package:boats_line/widgets_common/custom_textfield.dart';
import 'package:get/get.dart';

import '../../widgets_common/loading_indicator.dart';
import '../../widgets_common/our_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              //for responsivness we use velocityX
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              10.heightBox,
              "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
              15.heightBox,
              Obx(
                () => Column(
                  children: [
                    customTextField(
                        title: email,
                        hint: emailHint,
                        isPass: false,
                        controller: controller.emailController),
                    customTextField(
                        title: password,
                        hint: passwordHint,
                        isPass: true,
                        controller: controller.passwordController),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: forgetPass.text.make(),
                      ),
                    ),
                    5.heightBox,
                    controller.isLoading.value
                        ? loadingIndicator()
                        : ourButton(
                            color: redColor,
                            title: login,
                            textColor: whiteColor,
                            onPress: () async {
                              controller.isLoading(true);

                              await controller
                                  .loginMethod(context: context)
                                  .then((value) {
                                controller.isLoading(false);
                                controller.emailController.clear();
                                controller.passwordController.clear();

                                if (value != null) {
                                  //VxToast.show(context, msg: loggedin);

                                  // Wrap the toast notification within a Scaffold
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text(loggedin)),
                                  );
                                } else {
                                  controller.isLoading(false);
                                }
                              });
                            }).box.width(context.screenWidth - 50).make(),
                    5.heightBox,
                    createNewAccount.text.color(fontGrey).make(),
                    5.heightBox,
                    ourButton(
                        color: lightGolden,
                        title: signup,
                        textColor: redColor,
                        onPress: () {
                          Get.to(() => const SignupScreen());
                        }).box.width(context.screenWidth - 50).make(),
                    10.heightBox,
                    loginWith.text.color(fontGrey).make(),
                    5.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: lightGrey,
                            radius: 25,
                            child: Image.asset(
                              socialIconList[index],
                              width: 30,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
                    .box
                    .white
                    .rounded
                    .padding(
                      const EdgeInsets.all(16),
                    )
                    .width(context.screenWidth - 70)
                    .shadowSm
                    .make(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
