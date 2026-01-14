Write-Host "Initializing Flutter Clean Architecture Structure..."

$root = "lib"
$assetsRoot = "assets"

# ============ Create Assets ============
$assetFolders = @(
    "assets",
    "assets/images",
    "assets/icons",
    "assets/fonts",
    "assets/lottie"
)

foreach ($folder in $assetFolders) {
    if (!(Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder | Out-Null
        Write-Host "Created asset folder: $folder"
    }
}

# ============ App Layer ============
$appFolders = @(
    "app",
    "app/config",
    "app/constants",
    "app/resources",
    "app/routes",
    "app/theme",
    "app/styles",
    "app/widgets"
)

# ============ Domain Layer ============
$domainFolders = @(
    "domain",
    "domain/entities",
    "domain/repositories",
    "domain/usecases"
)

# ============ Presentation Layer ============
$presentationFolders = @(
    "presentation",
    "presentation/pages",
    "presentation/controllers",
    "presentation/widgets"
)

$folders = $appFolders + $domainFolders + $presentationFolders

foreach ($folder in $folders) {
    $path = Join-Path $root $folder
    if (!(Test-Path $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
        Write-Host "Created folder: $path"
    }
}

# ============ Sample Files ============
$files = @(
    "app/config/app_config.dart",
    "app/constants/app_constants.dart",
    "app/routes/app_routes.dart",
    "app/theme/app_theme.dart",
    "app/styles/app_styles.dart",
    "app/widgets/app_button.dart",

    "domain/entities/user.dart",
    "domain/repositories/user_repository.dart",
    "domain/usecases/get_user_usecase.dart",

    "presentation/pages/home_page.dart",
    "presentation/controllers/home_controller.dart",
    "presentation/widgets/home_header.dart"
)

foreach ($file in $files) {
    $path = Join-Path $root $file
    if (!(Test-Path $path)) {
        New-Item -ItemType File -Path $path | Out-Null
        Write-Host "Created file: $path"
    }
}

# ============ main.dart ============
$mainFile = Join-Path $root "main.dart"

if (!(Test-Path $mainFile)) {

$mainContent = @"
import 'package:flutter/material.dart';
import 'presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Architecture App',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
"@

    Set-Content -Path $mainFile -Value $mainContent -Encoding UTF8
    Write-Host "Created file: lib/main.dart"
}

# ============ Update pubspec.yaml ============
$pubspec = "pubspec.yaml"

if (Test-Path $pubspec) {
    $content = Get-Content $pubspec -Raw

    if ($content -notmatch "assets:") {
        $assetBlock = @"

  assets:
    - assets/images/
    - assets/icons/
    - assets/fonts/
    - assets/lottie/

"@

        $content = $content -replace "flutter:\s*", "flutter:`n$assetBlock"
        Set-Content -Path $pubspec -Value $content -Encoding UTF8

        Write-Host "Updated pubspec.yaml with assets"
    }
}

Write-Host "Flutter Clean Architecture structure initialized successfully!"
