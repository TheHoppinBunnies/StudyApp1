import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Image("forest")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                
                
                VStack(spacing: 40) {
                    HStack(spacing: 5) {
                        VStack {
                            Text("Choose your tool")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)
                                .padding()
                        }
                        .frame(width: 350)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.black.opacity(0.8))
                        )
                        
//                        Spacer()
                        Image(systemName: "gear.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35)
                            .foregroundStyle(.white)
                    }
                    
                    
                    // flashcards
                    NavigationLink(destination: FlashcardsView()) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black.opacity(0.5))
                            .frame(width: 300, height: 50)
                            .overlay(
                                Text("Flashcards")
                                    .foregroundColor(.white)
                                    .bold()
                            )
                    }
                    
                    // pomodoro
                    NavigationLink(destination: PomodoroTimerView()) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black.opacity(0.5))
                            .frame(width: 300, height: 50)
                            .overlay(
                                Text("Pomodoro")
                                    .foregroundColor(.white)
                                    .bold()
                            )
                    }
                    
                    // music
                    NavigationLink(destination: MusicView()) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black.opacity(0.5))
                            .frame(width: 300, height: 50)
                            .overlay(
                                Text("Music")
                                    .foregroundColor(.white)
                                    .bold()
                            )
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
