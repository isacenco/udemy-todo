//
//  SettingsView.swift
//  Todo App
//
//  Created by Ghenadie Isacenco on 31/10/2025.
//

import SwiftUI

struct SettingsView: View {
    // MARK: - PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var iconSettings: IconNames
    
    // THEME
    let themes: [Theme] = themeData
    @ObservedObject var theme = ThemeSettings.shared
    @State private var isThemeChanged = false
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                // MARK: - FORM
                Form {
                    // MARK: - SECTION 1
                    Section(header: Text("Choose the app icon")) {
                        Picker(selection: $iconSettings.currentIndex) {
                            ForEach(0 ..< iconSettings.iconNames.count, id: \.self) { index in
                                HStack {
                                    Image(
                                        uiImage: UIImage(named: iconSettings.iconNames[index] ?? "Blue") ?? UIImage()
                                    )
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 44, height: 44)
                                    .cornerRadius(9)
                                    
                                    Spacer().frame(width: 8)
                                    
                                    Text(iconSettings.iconNames[index] ?? "Blue")
                                        .frame(alignment: .leading)
                                } //: HSTACK
                                .padding(3)
                            }
                        } label: {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 9, style: .continuous)
                                        .strokeBorder(.primary, lineWidth: 2)
                                    Image(systemName: "paintbrush")
                                        .font(.system(size: 29, weight: .regular, design: .default))
                                        .foregroundColor(.primary)
                                }
                                .frame(width: 44, height: 44)
                                
                                Text("App Icons".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                            } //: LABEL
                            
                        } //: PICKER
                        .pickerStyle(.navigationLink)
                        .onReceive([self.iconSettings.currentIndex].publisher.first()) { (value) in
                            let index = self.iconSettings.iconNames.firstIndex(of: UIApplication.shared.alternateIconName) ?? 0
                            if index != value {
                                UIApplication.shared.setAlternateIconName(self.iconSettings.iconNames[value]) { error in
                                    if let error = error {
                                        print("Error setting alternate icon: \(error.localizedDescription)")
                                    } else {
                                        print("Success")
                                    }
                                }
                            }
                        }

                    } //: SECTION 1
                    .padding(.vertical, 3)
                    
                    // MARK: - SECTION 2
                    Section(header: HStack {
                        Text("Choose the app theme")
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(themes[theme.themeSettings].color)
                    }
                    ) {
                        List {
                            ForEach(themes, id: \.id) { item in
                                Button {
                                    theme.themeSettings = item.id
                                    UserDefaults.standard.set(theme.themeSettings, forKey: "Theme")
                                    isThemeChanged.toggle()
                                } label: {
                                    HStack {
                                        Image(systemName: "circle.fill")
                                            .foregroundColor(item.color)
                                        
                                        Text(item.name)
                                    }
                                } //: BUTTON
                                .accentColor(.primary)
                            }
                        }
                    } //: SECTION 2
                    .padding(.vertical, 3)
                    .alert(isPresented: $isThemeChanged) {
                        Alert(title: Text("Success"), message: Text("App has been changed to the \(themes[theme.themeSettings].name). Now close and restart it."), dismissButton: .default(Text("OK")))
                    }
 
                    // MARK: - SECTION 3
                    Section(header: Text("Follow us on social media")) {
                        FormRowLinkView(icon: "globe", color: .pink, text: "Website", link: "https://swiftuimasterclass.com")
                        FormRowLinkView(icon: "link", color: .blue, text: "Twitter", link: "https://x.com/robertpetras")
                        FormRowLinkView(icon: "play.rectangle", color: .green, text: "Courses", link: "https://udemy.com/user/robert-petras")
                    } //: SECTION 3
                    .padding(.vertical, 3)
                    
                    // MARK: - SECTION 4
                    
                    Section(header: Text("About the application")) {
                        FormRowStaticView(icon: "gear", firstText: "Application", secondText: "Todo")
                        FormRowStaticView(icon: "checkmark.seal", firstText: "Compatibility", secondText: "iPhone, iPad")
                        FormRowStaticView(icon: "keyboard", firstText: "Developer", secondText: "Ghenadie Isacenco")
                        FormRowStaticView(icon: "paintbrush", firstText: "Designer", secondText: "Robert Petras")
                        FormRowStaticView(icon: "flag", firstText: "Version", secondText: "1.0.0")
                    } //: SECTION $
                    .padding(.vertical, 3)
                } //: FORM
                .listStyle(.grouped)
                .environment(\.horizontalSizeClass, .regular)
                
                // MARK: - FOOTER
                Text("Copyright © All rights reserved.\nBetter Apps ♡ Less Code.")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .padding(.top, 6)
                    .padding(.bottom, 8)
                    .foregroundColor(.secondary)
            } //: VSTACK
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .accentColor(themes[theme.themeSettings].color)
            }))
            .navigationBarTitle("Settings", displayMode: .inline)
            .background(Color("ColorBackground").edgesIgnoringSafeArea(.all))
        } //: NAV
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}

// MARK: - PREVIEW
#Preview {
    SettingsView()
        .environmentObject(IconNames())
}

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height

        let scaleFactor = min(widthRatio, heightRatio)

        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize,
            ))
        }
        return scaledImage
    }
}
