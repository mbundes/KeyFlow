import SwiftUI

// MARK: - App Icon Concepts based on Sun + Fn menu bar icon
// Rendered at 512x512 (production icons are 1024x1024)

private let S: CGFloat = 512
private let R: CGFloat = 110  // corner radius
private let iBlue  = Color(red: 0.20, green: 0.48, blue: 1.00)
private let iOrange = Color(red: 240/255, green: 150/255, blue: 54/255)

// MARK: Helpers

private struct IconBase<Content: View>: View {
    var fill: AnyShapeStyle
    var content: () -> Content

    init(fill: AnyShapeStyle, @ViewBuilder content: @escaping () -> Content) {
        self.fill = fill
        self.content = content
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: R, style: .continuous)
                .fill(fill)
                .frame(width: S, height: S)
            content()
        }
    }
}

// 1. Blue gradient — sun large top, bold Fn bottom
struct AppIcon1: View {
    var body: some View {
        IconBase(fill: AnyShapeStyle(LinearGradient(
            colors: [Color(red: 0.25, green: 0.55, blue: 1.0), Color(red: 0.10, green: 0.30, blue: 0.85)],
            startPoint: .top, endPoint: .bottom))) {
            VStack(spacing: 28) {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 200))
                    .foregroundStyle(.white)
                Text("Fn")
                    .font(.system(size: 120, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
            }
        }
    }
}

// 2. Dark with glow — blue sun, white Fn
struct AppIcon2: View {
    var body: some View {
        IconBase(fill: AnyShapeStyle(Color(red: 0.08, green: 0.08, blue: 0.12))) {
            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(iBlue.opacity(0.35))
                        .frame(width: 280, height: 280)
                        .blur(radius: 40)
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 190))
                        .foregroundStyle(iBlue)
                }
                Text("Fn")
                    .font(.system(size: 110, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
            }
        }
    }
}

// 3. Orange gradient — white sun, white Fn
struct AppIcon3: View {
    var body: some View {
        IconBase(fill: AnyShapeStyle(LinearGradient(
            colors: [iOrange, Color(red: 0.85, green: 0.45, blue: 0.10)],
            startPoint: .topLeading, endPoint: .bottomTrailing))) {
            VStack(spacing: 24) {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 190))
                    .foregroundStyle(.white.opacity(0.9))
                Text("Fn")
                    .font(.system(size: 110, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
            }
        }
    }
}

// 4. Blue-orange diagonal split
struct AppIcon4: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: R, style: .continuous)
                .fill(iBlue)
                .frame(width: S, height: S)

            Path { p in
                p.move(to: CGPoint(x: 0, y: S * 0.52))
                p.addQuadCurve(
                    to: CGPoint(x: S, y: S * 0.48),
                    control: CGPoint(x: S / 2, y: S * 0.62)
                )
                p.addLine(to: CGPoint(x: S, y: S))
                p.addLine(to: CGPoint(x: 0, y: S))
            }
            .fill(iOrange)
            .frame(width: S, height: S)
            .clipShape(RoundedRectangle(cornerRadius: R, style: .continuous))

            VStack(spacing: 16) {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 190))
                    .foregroundStyle(.white)
                Text("Fn")
                    .font(.system(size: 120, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
            }
        }
        .frame(width: S, height: S)
    }
}

// 5. White/light — colored sun and Fn
struct AppIcon5: View {
    var body: some View {
        IconBase(fill: AnyShapeStyle(Color.white)) {
            VStack(spacing: 20) {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 200))
                    .foregroundStyle(iBlue)
                Text("Fn")
                    .font(.system(size: 120, weight: .black, design: .rounded))
                    .foregroundStyle(iOrange)
            }
        }
    }
}

// 6. Purple-blue gradient, tighter layout
struct AppIcon6: View {
    var body: some View {
        IconBase(fill: AnyShapeStyle(LinearGradient(
            colors: [Color(red: 0.35, green: 0.20, blue: 0.90), Color(red: 0.15, green: 0.40, blue: 0.95)],
            startPoint: .topLeading, endPoint: .bottomTrailing))) {
            HStack(spacing: 32) {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 160))
                    .foregroundStyle(.white)
                Text("Fn")
                    .font(.system(size: 140, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
            }
        }
    }
}

// 7. Sun rays radiating, Fn centered
struct AppIcon7: View {
    var body: some View {
        IconBase(fill: AnyShapeStyle(LinearGradient(
            colors: [Color(red: 0.15, green: 0.35, blue: 0.90), Color(red: 0.05, green: 0.20, blue: 0.70)],
            startPoint: .top, endPoint: .bottom))) {
            ZStack {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 420))
                    .foregroundStyle(.white.opacity(0.12))
                VStack(spacing: 0) {
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 180))
                        .foregroundStyle(.white)
                    Text("Fn")
                        .font(.system(size: 130, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                        .offset(y: -10)
                }
            }
        }
    }
}

// 8. Sun inside rounded square, Fn below
struct AppIcon8: View {
    var body: some View {
        IconBase(fill: AnyShapeStyle(Color(red: 0.10, green: 0.12, blue: 0.18))) {
            VStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 48, style: .continuous)
                        .fill(iBlue.opacity(0.25))
                        .frame(width: 240, height: 240)
                    RoundedRectangle(cornerRadius: 48, style: .continuous)
                        .stroke(iBlue.opacity(0.6), lineWidth: 2)
                        .frame(width: 240, height: 240)
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 140))
                        .foregroundStyle(iBlue)
                }
                Text("Fn")
                    .font(.system(size: 110, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
            }
        }
    }
}

// 9. Gradient text on neutral dark
struct AppIcon9: View {
    var body: some View {
        IconBase(fill: AnyShapeStyle(Color(red: 0.12, green: 0.12, blue: 0.15))) {
            VStack(spacing: 16) {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 190))
                    .foregroundStyle(
                        LinearGradient(colors: [.white, iBlue], startPoint: .top, endPoint: .bottom)
                    )
                Text("Fn")
                    .font(.system(size: 120, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(colors: [iBlue, iOrange], startPoint: .leading, endPoint: .trailing)
                    )
            }
        }
    }
}

// 10. Compact — sun and Fn side by side, bold color block
struct AppIcon10: View {
    var body: some View {
        IconBase(fill: AnyShapeStyle(LinearGradient(
            colors: [iBlue, iOrange],
            startPoint: .topLeading, endPoint: .bottomTrailing))) {
            VStack(spacing: 12) {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 200))
                    .foregroundStyle(.white)
                Text("Fn")
                    .font(.system(size: 110, weight: .black, design: .rounded))
                    .foregroundStyle(.white.opacity(0.9))
            }
        }
    }
}

// MARK: - Variant 2 explorations: dark bg + sun glow + Fn

// 2a. Original
struct AppIcon2a: View {
    var body: some View {
        IconBase(fill: AnyShapeStyle(Color(red: 0.08, green: 0.08, blue: 0.12))) {
            VStack(spacing: 24) {
                ZStack {
                    Circle().fill(iBlue.opacity(0.35)).frame(width: 280, height: 280).blur(radius: 40)
                    Image(systemName: "sun.max.fill").font(.system(size: 190)).foregroundStyle(iBlue)
                }
                Text("Fn").font(.system(size: 110, weight: .black, design: .rounded)).foregroundStyle(.white)
            }
        }
    }
}

// 2b. Orange glow instead of blue
struct AppIcon2b: View {
    var body: some View {
        IconBase(fill: AnyShapeStyle(Color(red: 0.08, green: 0.07, blue: 0.05))) {
            VStack(spacing: 24) {
                ZStack {
                    Circle().fill(iOrange.opacity(0.40)).frame(width: 280, height: 280).blur(radius: 45)
                    Image(systemName: "sun.max.fill").font(.system(size: 190)).foregroundStyle(iOrange)
                }
                Text("Fn").font(.system(size: 110, weight: .black, design: .rounded)).foregroundStyle(.white)
            }
        }
    }
}

// 2c. Blue sun, orange Fn
struct AppIcon2c: View {
    var body: some View {
        IconBase(fill: AnyShapeStyle(Color(red: 0.07, green: 0.07, blue: 0.10))) {
            VStack(spacing: 20) {
                ZStack {
                    Circle().fill(iBlue.opacity(0.30)).frame(width: 260, height: 260).blur(radius: 40)
                    Image(systemName: "sun.max.fill").font(.system(size: 180)).foregroundStyle(iBlue)
                }
                Text("Fn").font(.system(size: 120, weight: .black, design: .rounded)).foregroundStyle(iOrange)
            }
        }
    }
}

// 2d. Dual glow — blue sun + orange halo behind Fn
struct AppIcon2d: View {
    var body: some View {
        IconBase(fill: AnyShapeStyle(Color(red: 0.07, green: 0.07, blue: 0.10))) {
            VStack(spacing: 16) {
                ZStack {
                    Circle().fill(iBlue.opacity(0.30)).frame(width: 260, height: 260).blur(radius: 38)
                    Image(systemName: "sun.max.fill").font(.system(size: 185)).foregroundStyle(iBlue)
                }
                ZStack {
                    Capsule().fill(iOrange.opacity(0.25)).frame(width: 220, height: 90).blur(radius: 24)
                    Text("Fn").font(.system(size: 115, weight: .black, design: .rounded)).foregroundStyle(iOrange)
                }
            }
        }
    }
}

// 2e. Slightly lighter dark, bigger sun, smaller Fn
struct AppIcon2e: View {
    var body: some View {
        IconBase(fill: AnyShapeStyle(Color(red: 0.11, green: 0.12, blue: 0.17))) {
            VStack(spacing: 10) {
                ZStack {
                    Circle().fill(iBlue.opacity(0.28)).frame(width: 310, height: 310).blur(radius: 50)
                    Image(systemName: "sun.max.fill").font(.system(size: 220)).foregroundStyle(iBlue)
                }
                Text("Fn").font(.system(size: 90, weight: .black, design: .rounded)).foregroundStyle(.white.opacity(0.85))
            }
        }
    }
}

// 2f. Sun outline + glow
struct AppIcon2f: View {
    var body: some View {
        IconBase(fill: AnyShapeStyle(Color(red: 0.07, green: 0.07, blue: 0.10))) {
            VStack(spacing: 20) {
                ZStack {
                    Circle().fill(iBlue.opacity(0.20)).frame(width: 260, height: 260).blur(radius: 35)
                    Image(systemName: "sun.max").font(.system(size: 185, weight: .thin)).foregroundStyle(iBlue)
                }
                Text("Fn").font(.system(size: 115, weight: .black, design: .rounded)).foregroundStyle(.white)
            }
        }
    }
}

// 2g. Tight — glow sun and Fn close together, centered
struct AppIcon2g: View {
    var body: some View {
        IconBase(fill: AnyShapeStyle(
            LinearGradient(colors: [Color(red: 0.10, green: 0.10, blue: 0.16), Color(red: 0.05, green: 0.05, blue: 0.10)],
                           startPoint: .top, endPoint: .bottom))) {
            ZStack {
                Circle().fill(iBlue.opacity(0.25)).frame(width: 380, height: 380).blur(radius: 60)
                VStack(spacing: -8) {
                    Image(systemName: "sun.max.fill").font(.system(size: 195)).foregroundStyle(iBlue)
                    Text("Fn").font(.system(size: 130, weight: .black, design: .rounded)).foregroundStyle(.white)
                }
            }
        }
    }
}

// 2h. Warm dark (slightly brownish) + blue sun
struct AppIcon2h: View {
    var body: some View {
        IconBase(fill: AnyShapeStyle(
            LinearGradient(colors: [Color(red: 0.10, green: 0.08, blue: 0.08), Color(red: 0.06, green: 0.05, blue: 0.05)],
                           startPoint: .top, endPoint: .bottom))) {
            VStack(spacing: 18) {
                ZStack {
                    Circle().fill(iBlue.opacity(0.28)).frame(width: 270, height: 270).blur(radius: 42)
                    Image(systemName: "sun.max.fill").font(.system(size: 188)).foregroundStyle(iBlue)
                }
                Text("Fn").font(.system(size: 112, weight: .black, design: .rounded)).foregroundStyle(.white)
            }
        }
    }
}

// 2i. Navy blue dark bg + crisp white sun + Fn
struct AppIcon2i: View {
    var body: some View {
        IconBase(fill: AnyShapeStyle(
            LinearGradient(colors: [Color(red: 0.07, green: 0.10, blue: 0.22), Color(red: 0.04, green: 0.06, blue: 0.15)],
                           startPoint: .topLeading, endPoint: .bottomTrailing))) {
            VStack(spacing: 22) {
                ZStack {
                    Circle().fill(Color.white.opacity(0.12)).frame(width: 260, height: 260).blur(radius: 36)
                    Image(systemName: "sun.max.fill").font(.system(size: 185)).foregroundStyle(.white)
                }
                Text("Fn").font(.system(size: 112, weight: .black, design: .rounded)).foregroundStyle(.white)
            }
        }
    }
}

// 2j. Horizontal layout on dark — sun left, Fn right, glow behind both
struct AppIcon2j: View {
    var body: some View {
        IconBase(fill: AnyShapeStyle(Color(red: 0.07, green: 0.07, blue: 0.10))) {
            ZStack {
                Ellipse().fill(iBlue.opacity(0.22)).frame(width: 460, height: 200).blur(radius: 50)
                HStack(spacing: 28) {
                    Image(systemName: "sun.max.fill").font(.system(size: 170)).foregroundStyle(iBlue)
                    Text("Fn").font(.system(size: 150, weight: .black, design: .rounded)).foregroundStyle(.white)
                }
            }
        }
    }
}

// MARK: - Grid preview

#Preview("Variant 2 — Dark Glow") {
    LazyVGrid(columns: Array(repeating: GridItem(.fixed(180)), count: 5), spacing: 20) {
        icon2(AppIcon2a(), "2a")
        icon2(AppIcon2b(), "2b")
        icon2(AppIcon2c(), "2c")
        icon2(AppIcon2d(), "2d")
        icon2(AppIcon2e(), "2e")
        icon2(AppIcon2f(), "2f")
        icon2(AppIcon2g(), "2g")
        icon2(AppIcon2h(), "2h")
        icon2(AppIcon2i(), "2i")
        icon2(AppIcon2j(), "2j")
    }
    .padding(30)
    .background(Color(white: 0.15))
}

private func icon2<V: View>(_ v: V, _ label: String) -> some View {
    VStack(spacing: 8) {
        v.scaleEffect(180.0 / S).frame(width: 180, height: 180)
        Text(label).font(.caption).foregroundStyle(.secondary)
    }
}


