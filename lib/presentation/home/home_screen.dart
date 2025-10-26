import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hy_guard/core/config/language/l10n/app_localization.dart';
import 'package:hy_guard/core/constant/app_routes_names.dart';
import 'package:hy_guard/core/constant/assets_names.dart';
import 'package:hy_guard/presentation/home/widgets/categories_bar.dart';
import 'package:hy_guard/presentation/home/widgets/storage_options.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, index) {
            return [_buildAppBar()];
          },
          body: ListView(
            padding: REdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: [
              _buildRecentFilesBar(),
              SizedBox(height: 20.h),
              Divider(),
              SizedBox(height: 20.h),
              FileCategoriesGrid(),
              SizedBox(height: 20.h),
              StorageOptions(),
              SizedBox(height: 20.h),
              _buildUtilitiesBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      title: _buildAppBarTitle(),
      centerTitle: true,
      actions: _buildAppBarActions(),
    );
  }

  Widget _buildAppBarTitle() {
    return Text("HY Guard");
  }

  List<Widget> _buildAppBarActions() {
    return [_buildProfileButton(), _buildSettingButton()];
  }

  Widget _buildProfileButton() {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(AppRoutesNames.search);
      },
      icon: Icon(Icons.search),
    );
  }

  Widget _buildSettingButton() {
    return IconButton(
      onPressed: () {},
      icon: _buildAppBarActionIcon(AssetsNames.settingsIcon),
    );
  }

  Widget _buildAppBarActionIcon(String icon) {
    return Image.asset(
      icon,
      color: Theme.of(context).iconTheme.color,
      width: 20.r,
      height: 20.r,
    );
  }

  Widget _buildRecentFilesBar() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutesNames.recentFiles);
      },
      child: _buildIconTitleTile(
        AssetsNames.recentFilesIcon,
        AppLocalizations.of(context)!.recent_files,
        null,
      ),
    );
  }

  Widget _buildUtilitiesBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.utilities,
          style: TextTheme.of(
            context,
          ).titleLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),
        _buildRecycleBinButton(),
      ],
    );
  }

  Widget _buildRecycleBinButton() {
    return GestureDetector(
      child: _buildIconTitleTile(
        AssetsNames.deleteIcon,
        AppLocalizations.of(context)!.recycle_bin,
        Theme.of(context).iconTheme.color,
      ),
    );
  }

  Widget _buildIconTitleTile(String icon, String name, Color? color) {
    return ListTile(
      leading: Image.asset(icon, width: 20.r, height: 20.r, color: color),
      title: Text(name, style: TextTheme.of(context).bodyLarge, maxLines: 1),
    );
  }
}
