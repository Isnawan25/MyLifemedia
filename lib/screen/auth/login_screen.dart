import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/base/popup/toast.dart';
import 'package:mylm/data/cubit/verify/verify_cubit.dart';
import 'package:mylm/data/network/services/post/post_auth_otp.dart';
import 'package:mylm/screen/auth/verify_screen.dart';
import 'package:mylm/screen/guest/welcome_screen.dart';
import 'package:mylm/data/cubit/login/login_cubit.dart';
import 'package:mylm/data/cubit/login/login_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.error) {
            showCustomErrorToast(context, state.message);
          }

          if (state.status == LoginStatus.success) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (_) => VerifyCubit(),
                  child: VerifyScreen(
                    custNumber: state.custNumber,
                    accessToken: state.accessToken,
                    custGroupId: state.custGroupId,
                    mainCustNumber: "",
                    newCustNumber: "",
                    password: state.password,

                    custName: state.custName,
                    custPhone: state.custPhone,
                    custEmail: state.custEmail,
                    custAddress: state.custAddress,
                    custProvince: state.custProvince,
                    custDistrict: state.custDistrict,
                    custSubDistrict: state.custSubDistrict,
                    custVillage: state.custVillage,
                    mode: OtpMode.login,
                  ),
                ),
              ),
            );
          }

        },
        child: const _LoginView(),
      ),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {

    final cubit = context.read<LoginCubit>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/svgs/arrow_back.svg",
            colorFilter: const ColorFilter.mode(
              Colors.black,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => WelcomeScreen(),
            ),
          ),
        ),
        title: Text(
          "Masuk",
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Text(
              "Selamat Datang",
              style: GoogleFonts.inter(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Silahkan masukan ID pelanggan dan password akun Life Media Anda",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            //ID PELANGGAN

            TextField(
              textCapitalization:
              TextCapitalization.characters,

              onChanged: cubit.onIdChanged,

              decoration: InputDecoration(
                labelText: "ID Pelanggan",

                labelStyle: GoogleFonts.inter(
                  color: Colors.grey[600],
                ),

                filled: true,
                fillColor: Colors.grey[100],

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),

                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // PASSWORD

            TextField(
              obscureText: _obscurePassword,

              onChanged: cubit.onPasswordChanged,

              decoration: InputDecoration(
                labelText: "Password",

                labelStyle: GoogleFonts.inter(
                  color: Colors.grey[600],
                ),

                filled: true,
                fillColor: Colors.grey[100],

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),

                  borderSide: BorderSide.none,
                ),

                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword =
                      !_obscurePassword;
                    });
                  },

                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,

                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            //BUTTON LOGIN

            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {

                final isLoading =
                    state.status ==
                        LoginStatus.loading;

                return Center(
                  child: GestureDetector(

                    onTap: state.isValid &&
                        !isLoading
                        ? () => cubit.login()
                        : null,

                    child: Container(
                      width: 250.w,
                      height: 50.h,

                      alignment: Alignment.center,

                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(30),

                        gradient: state.isValid
                            ? const LinearGradient(
                          colors: [
                            darkorange,
                            orange,
                          ],
                        )
                            : null,

                        color: state.isValid
                            ? null
                            : Colors.grey[300],
                      ),

                      child: isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )

                          : Text(
                        "Masuk",

                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight:
                          FontWeight.w600,

                          color: state.isValid
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
