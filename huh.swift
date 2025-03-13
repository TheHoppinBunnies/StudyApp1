import SwiftUI
import CoreLocation
import MapKit
import HealthKit
import AVFoundation
import UserNotifications

// MARK: - App Entry Point
@main
struct TelemedicineApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

// MARK: - App State
class AppState: ObservableObject {
    @Published var user: User?
    @Published var isLoggedIn = false
    @Published var currentTab: Tab = .home
    @Published var appointments: [Appointment] = []
    @Published var medications: [Medication] = []
    @Published var vitalSigns: [VitalSign] = []
    @Published var chatHistory: [ChatMessage] = []
    @Published var nearbyHospitals: [Hospital] = []
    
    enum Tab {
        case home, chat, appointments, medications, profile
    }
    
    func login(email: String, password: String) {
        // Simulate authentication
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.user = User(id: UUID().uuidString, name: "John Doe", email: email)
            self.isLoggedIn = true
            self.loadUserData()
        }
    }
    
    func logout() {
        self.user = nil
        self.isLoggedIn = false
    }
    
    func loadUserData() {
        // Simulate loading data
        self.appointments = sampleAppointments
        self.medications = sampleMedications
        self.vitalSigns = sampleVitalSigns
        self.chatHistory = sampleChatHistory
    }
    
    func searchNearbyHospitals(location: CLLocation) {
        // This would use MKLocalSearch in a real implementation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.nearbyHospitals = sampleHospitals
        }
    }
}

// MARK: - Models
struct User: Identifiable {
    let id: String
    let name: String
    let email: String
    var profileImage: String? = "person.circle.fill"
    var dateOfBirth: Date = Date(timeIntervalSince1970: 0)
    var bloodType: String = "O+"
    var allergies: [String] = ["Peanuts", "Penicillin"]
    var conditions: [String] = ["Asthma"]
}

struct Appointment: Identifiable {
    let id: UUID
    let doctorName: String
    let specialty: String
    let date: Date
    let isVideoCall: Bool
    var status: AppointmentStatus
    
    enum AppointmentStatus: String {
        case scheduled, completed, cancelled
    }
}

struct Medication: Identifiable {
    let id: UUID
    let name: String
    let dosage: String
    let schedule: [Date]
    let instructions: String
    var refillDate: Date?
}

struct VitalSign: Identifiable {
    let id: UUID
    let type: VitalType
    let value: Double
    let unit: String
    let timestamp: Date
    
    enum VitalType: String {
        case heartRate = "Heart Rate"
        case bloodPressure = "Blood Pressure"
        case bloodOxygen = "Blood Oxygen"
        case temperature = "Temperature"
        case respiratoryRate = "Respiratory Rate"
    }
}

struct ChatMessage: Identifiable {
    let id: UUID
    let sender: MessageSender
    let content: String
    let timestamp: Date
    var isRead: Bool
    
    enum MessageSender {
        case user, ai, doctor
    }
}

struct Hospital: Identifiable {
    let id: UUID
    let name: String
    let address: String
    let distance: Double // in km
    let coordinates: CLLocationCoordinate2D
    let phone: String
    let rating: Double // out of 5
}

// MARK: - Sample Data
let sampleAppointments: [Appointment] = [
    Appointment(id: UUID(), doctorName: "Dr. Sarah Johnson", specialty: "Cardiology", date: Date().addingTimeInterval(86400), isVideoCall: true, status: .scheduled),
    Appointment(id: UUID(), doctorName: "Dr. Michael Chen", specialty: "General Practice", date: Date().addingTimeInterval(-172800), isVideoCall: false, status: .completed),
    Appointment(id: UUID(), doctorName: "Dr. Lisa Rodriguez", specialty: "Dermatology", date: Date().addingTimeInterval(432000), isVideoCall: true, status: .scheduled)
]

let sampleMedications: [Medication] = [
    Medication(id: UUID(), name: "Lisinopril", dosage: "10mg", schedule: [Date()], instructions: "Take once daily with food", refillDate: Date().addingTimeInterval(1296000)),
    Medication(id: UUID(), name: "Metformin", dosage: "500mg", schedule: [Date(), Date().addingTimeInterval(43200)], instructions: "Take twice daily with meals", refillDate: Date().addingTimeInterval(864000)),
    Medication(id: UUID(), name: "Ibuprofen", dosage: "200mg", schedule: [Date()], instructions: "Take as needed for pain", refillDate: nil)
]

let sampleVitalSigns: [VitalSign] = [
    VitalSign(id: UUID(), type: .heartRate, value: 72, unit: "bpm", timestamp: Date().addingTimeInterval(-3600)),
    VitalSign(id: UUID(), type: .bloodPressure, value: 120/80, unit: "mmHg", timestamp: Date().addingTimeInterval(-7200)),
    VitalSign(id: UUID(), type: .bloodOxygen, value: 98, unit: "%", timestamp: Date().addingTimeInterval(-3600)),
    VitalSign(id: UUID(), type: .temperature, value: 98.6, unit: "°F", timestamp: Date().addingTimeInterval(-86400)),
    VitalSign(id: UUID(), type: .respiratoryRate, value: 16, unit: "bpm", timestamp: Date().addingTimeInterval(-3600))
]

let sampleChatHistory: [ChatMessage] = [
    ChatMessage(id: UUID(), sender: .ai, content: "Hello! How can I help you today?", timestamp: Date().addingTimeInterval(-3600), isRead: true),
    ChatMessage(id: UUID(), sender: .user, content: "I've been having a sore throat for the past 3 days.", timestamp: Date().addingTimeInterval(-3540), isRead: true),
    ChatMessage(id: UUID(), sender: .ai, content: "I'm sorry to hear that. Do you have any other symptoms like fever or cough?", timestamp: Date().addingTimeInterval(-3500), isRead: true),
    ChatMessage(id: UUID(), sender: .doctor, content: "Hi, I'm Dr. Johnson. I see you're having a sore throat. Let's discuss this further.", timestamp: Date().addingTimeInterval(-1800), isRead: true)
]

let sampleHospitals: [Hospital] = [
    Hospital(id: UUID(), name: "Memorial General Hospital", address: "123 Medical Ave, City", distance: 2.3, coordinates: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), phone: "555-123-4567", rating: 4.5),
    Hospital(id: UUID(), name: "City Medical Center", address: "456 Healthcare Blvd, City", distance: 3.8, coordinates: CLLocationCoordinate2D(latitude: 37.7833, longitude: -122.4167), phone: "555-987-6543", rating: 4.2),
    Hospital(id: UUID(), name: "University Hospital", address: "789 Treatment St, City", distance: 5.1, coordinates: CLLocationCoordinate2D(latitude: 37.7694, longitude: -122.4862), phone: "555-456-7890", rating: 4.7)
]

// MARK: - Main Content View
struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        if appState.isLoggedIn {
            MainTabView()
        } else {
            LoginView()
        }
    }
}

// MARK: - Login View
struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 30) {
            // Logo and Title
            VStack {
                Image(systemName: "heart.text.square.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                Text("MediConnect")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("AI-Powered Telemedicine")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Login Form
            VStack(spacing: 15) {
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                Button(action: {
                    isLoading = true
                    appState.login(email: email, password: password)
                }) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    } else {
                        Text("Sign In")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .disabled(email.isEmpty || password.isEmpty || isLoading)
                
                Button("Create an account") {
                    // Navigate to sign up
                }
                .foregroundColor(.blue)
                
                Button("Forgot password?") {
                    // Navigate to password reset
                }
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView(selection: $appState.currentTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(AppState.Tab.home)
            
            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "message.fill")
                }
                .tag(AppState.Tab.chat)
            
            AppointmentsView()
                .tabItem {
                    Label("Appointments", systemImage: "calendar")
                }
                .tag(AppState.Tab.appointments)
            
            MedicationsView()
                .tabItem {
                    Label("Medications", systemImage: "pill.fill")
                }
                .tag(AppState.Tab.medications)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(AppState.Tab.profile)
        }
    }
}

// MARK: - Home View
struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showEmergencyAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Emergency Button
                    Button(action: {
                        showEmergencyAlert = true
                    }) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 22))
                            Text("Emergency")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    // Quick Actions
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        NavigationLink(destination: VideoCallView(isAI: true)) {
                            QuickActionButton(icon: "video.fill", title: "AI Consultation", color: .blue)
                        }
                        
                        NavigationLink(destination: NearbyHospitalsView()) {
                            QuickActionButton(icon: "building.2.fill", title: "Nearby Hospitals", color: .green)
                        }
                        
                        NavigationLink(destination: VitalSignsView()) {
                            QuickActionButton(icon: "waveform.path.ecg", title: "Vital Signs", color: .orange)
                        }
                        
                        NavigationLink(destination: ChatView()) {
                            QuickActionButton(icon: "message.fill", title: "Chat with AI", color: .purple)
                        }
                    }
                    
                    // Upcoming Appointments
                    VStack(alignment: .leading) {
                        Text("Upcoming Appointments")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        if let nextAppointment = appState.appointments.filter({ $0.status == .scheduled && $0.date > Date() }).sorted(by: { $0.date < $1.date }).first {
                            AppointmentCard(appointment: nextAppointment)
                        } else {
                            Text("No upcoming appointments")
                                .foregroundColor(.secondary)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                        
                        NavigationLink(destination: AppointmentsView()) {
                            Text("View All")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .padding(.top, 5)
                        }
                    }
                    
                    // Medication Reminders
                    VStack(alignment: .leading) {
                        Text("Medication Reminders")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        ForEach(appState.medications.prefix(2)) { medication in
                            MedicationReminderCard(medication: medication)
                        }
                        
                        NavigationLink(destination: MedicationsView()) {
                            Text("View All")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .padding(.top, 5)
                        }
                    }
                    
                    // Recent Vital Signs
                    VStack(alignment: .leading) {
                        Text("Recent Vital Signs")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(appState.vitalSigns.prefix(4)) { vitalSign in
                                    VitalSignCard(vitalSign: vitalSign)
                                }
                            }
                        }
                        
                        NavigationLink(destination: VitalSignsView()) {
                            Text("View All")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .padding(.top, 5)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("MediConnect")
            .alert(isPresented: $showEmergencyAlert) {
                Alert(
                    title: Text("Emergency"),
                    message: Text("Call emergency services (911)?"),
                    primaryButton: .destructive(Text("Call 911")) {
                        // In a real app, this would use URL(string: "tel:911") to call
                        print("Calling 911")
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct AppointmentCard: View {
    let appointment: Appointment
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(appointment.doctorName)
                    .font(.headline)
                Text(appointment.specialty)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    Image(systemName: appointment.isVideoCall ? "video.fill" : "person.fill")
                    Text(appointment.isVideoCall ? "Video Call" : "In Person")
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5) {
                Text(dateFormatter.string(from: appointment.date))
                    .font(.subheadline)
                Text(timeFormatter.string(from: appointment.date))
                    .font(.headline)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
}

struct MedicationReminderCard: View {
    let medication: Medication
    
    var body: some View {
        HStack {
            Image(systemName: "pill.fill")
                .font(.system(size: 25))
                .foregroundColor(.blue)
                .padding(.trailing, 5)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(medication.name)
                    .font(.headline)
                Text("\(medication.dosage) - \(medication.instructions)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if let nextDose = medication.schedule.first(where: { $0 > Date() }) {
                Text(timeFormatter.string(from: nextDose))
                    .font(.headline)
                    .foregroundColor(.orange)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
}

struct VitalSignCard: View {
    let vitalSign: VitalSign
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Text(vitalSign.type.rawValue)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("\(Int(vitalSign.value))")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(vitalSignColor(for: vitalSign))
            
            Text(vitalSign.unit)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(width: 100, height: 100)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    func vitalSignColor(for vitalSign: VitalSign) -> Color {
        switch vitalSign.type {
        case .heartRate:
            if vitalSign.value < 60 || vitalSign.value > 100 {
                return .orange
            }
        case .bloodPressure:
            if vitalSign.value > 130 {
                return .red
            }
        case .bloodOxygen:
            if vitalSign.value < 95 {
                return .orange
            } else if vitalSign.value < 90 {
                return .red
            }
        case .temperature:
            if vitalSign.value > 99.5 {
                return .orange
            } else if vitalSign.value > 100.4 {
                return .red
            }
        case .respiratoryRate:
            if vitalSign.value < 12 || vitalSign.value > 20 {
                return .orange
            }
        }
        return .green
    }
}

// MARK: - Chat View
struct ChatView: View {
    @EnvironmentObject var appState: AppState
    @State private var newMessage = ""
    @State private var showContactDoctorSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Chat messages
                ScrollViewReader { scrollView in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(appState.chatHistory) { message in
                                ChatBubble(message: message)
                            }
                            .onChange(of: appState.chatHistory.count) { _ in
                                if let lastMessage = appState.chatHistory.last {
                                    scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                        .padding()
                    }
                }
                
                // Message input
                HStack {
                    TextField("Type a message", text: $newMessage)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                    }
                    .disabled(newMessage.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Chat with AI")
            .navigationBarItems(trailing:
                Button(action: {
                    showContactDoctorSheet = true
                }) {
                    Image(systemName: "video.fill")
                        .foregroundColor(.blue)
                }
            )
            .sheet(isPresented: $showContactDoctorSheet) {
                ContactDoctorView()
            }
        }
    }
    
    func sendMessage() {
        guard !newMessage.isEmpty else { return }
        
        let userMessage = ChatMessage(
            id: UUID(),
            sender: .user,
            content: newMessage,
            timestamp: Date(),
            isRead: true
        )
        
        appState.chatHistory.append(userMessage)
        let messageSent = newMessage
        newMessage = ""
        
        // Simulate AI response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let aiResponse = simulateAIResponse(to: messageSent)
            appState.chatHistory.append(aiResponse)
        }
    }
    
    func simulateAIResponse(to message: String) -> ChatMessage {
        let responses = [
            "I understand your concerns. Based on your symptoms, it could be a common cold or allergies. Would you like more information about these conditions?",
            "Your symptoms might indicate a mild infection. It's important to stay hydrated and rest. Would you like me to suggest some over-the-counter medications?",
            "I've analyzed your symptoms. While I can provide general guidance, it might be best to consult with a doctor. Would you like me to help schedule an appointment?",
            "Based on the information you've shared, these symptoms are common for seasonal allergies. Have you experienced these symptoms before during this time of year?"
        ]
        
        return ChatMessage(
            id: UUID(),
            sender: .ai,
            content: responses.randomElement() ?? "I'm here to help. Can you provide more details about your symptoms?",
            timestamp: Date(),
            isRead: true
        )
    }
}

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.sender == .user {
                Spacer()
            }
            
            VStack(alignment: message.sender == .user ? .trailing : .leading, spacing: 2) {
                Text(senderName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(message.content)
                    .padding(10)
                    .background(bubbleColor)
                    .foregroundColor(textColor)
                    .cornerRadius(15)
                
                Text(timeFormatter.string(from: message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            if message.sender != .user {
                Spacer()
            }
        }
    }
    
    private var senderName: String {
        switch message.sender {
        case .user:
            return "You"
        case .ai:
            return "AI Assistant"
        case .doctor:
            return "Doctor"
        }
    }
    
    private var bubbleColor: Color {
        switch message.sender {
        case .user:
            return .blue
        case .ai:
            return Color(.systemGray5)
        case .doctor:
            return .green
        }
    }
    
    private var textColor: Color {
        message.sender == .user ? .white : .primary
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
}

struct ContactDoctorView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDoctor: String = "Dr. Sarah Johnson"
    @State private var reason: String = ""
    
    let doctors = [
        "Dr. Sarah Johnson (Cardiology)",
        "Dr. Michael Chen (General Practice)",
        "Dr. Lisa Rodriguez (Dermatology)"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Contact a Doctor")) {
                    Picker("Select Doctor", selection: $selectedDoctor) {
                        ForEach(doctors, id: \.self) { doctor in
                            Text(doctor)
                        }
                    }
                    
                    TextField("Reason for consultation", text: $reason)
                        .frame(height: 100, alignment: .top)
                        .multilineTextAlignment(.leading)
                }
                
                Section {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        // This would navigate to VideoCallView in a real app
                    }) {
                        HStack {
                            Image(systemName: "video.fill")
                            Text("Start Video Call")
                        }
                    }
                    .foregroundColor(.blue)
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        // This would navigate to ChatView with doctor in a real app
                    }) {
                        HStack {
                            Image(systemName: "message.fill")
                            Text("Send Message")
                        }
                    }
                    .foregroundColor(.green)
                }
            }
            .navigationTitle("Contact Doctor")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// MARK: - Appointments View
struct AppointmentsView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingBookAppointment = false
    @State private var selectedSegment = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $selectedSegment) {
                    Text("Upcoming").tag(0)
                    Text("Past").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                if selectedAppointments.isEmpty {
                    ContentUnavailableView(
                        label: {
                            Label(selectedSegment == 0 ? "No Upcoming Appointments" : "No Past Appointments",
                                  systemImage: "calendar.badge.exclamationmark")
                        },
                        description: {
                            Text(selectedSegment == 0 ? "Schedule an appointment with a doctor" : "Your past appointments will appear here")
                        },
                        actions: {
                            if selectedSegment == 0 {
                                Button("Book Appointment") {
                                    showingBookAppointment = true
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    )
                } else {
                    List {
                        ForEach(selectedAppointments) { appointment in
                            AppointmentRow(appointment: appointment)
                        }
                    }
                }
            }
            .navigationTitle("Appointments")
            .navigationBarItems(trailing:
                Button(action: {
                    showingBookAppointment = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showingBookAppointment) {
                BookAppointmentView()
            }
        }
    }
    
    private var selectedAppointments: [Appointment] {
        if selectedSegment == 0 {
            return appState.appointments.filter { $0.date > Date() && $0.status == .scheduled }
                .sorted { $0.date < $1.date }
        } else {
            return appState.appointments.filter { $0.date < Date() || $0.status == .cancelled }
                .sorted { $0.date > $1.date }
        }
    }
}

struct AppointmentRow: View {
    let appointment: Appointment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(appointment.doctorName)
                    .font(.headline)
                Spacer()
                StatusBadge(status: appointment.status)
            }
            
            Text(appointment.specialty)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.blue)
                Text(dateFormatter.string(from: appointment.date))
                
                Image(systemName: "clock")
                    .foregroundColor(.blue)
                    .padding(.leading, 5)
                Text(timeFormatter.string(from: appointment.date))
            }
            .font(.caption)
            .padding(.top, 2)
            
            HStack {
                Image(systemName: appointment.isVideoCall ? "video.fill" : "person.fill")
                    .foregroundColor(.blue)
                Text(appointment.isVideoCall ? "Video Call" : "In-person")
                    .font(.caption)
            }
        }
        .padding(.vertical, 5)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
}

struct StatusBadge: View {
    let status: Appointment.AppointmentStatus
    
    var body: some View {
        Text(status.rawValue.capitalized)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(statusColor)
            .foregroundColor(.white)
            .cornerRadius(5)
    }
    
    private var statusColor: Color {
        switch status {
        case .scheduled:
            return .blue
        case .completed:
            return .green
        case .cancelled:
            return .red
        }
    }
}

struct BookAppointmentView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedDoctor = "Dr. Sarah Johnson"
    @State private var selectedSpecialty = "Cardiology"
    @State private var selectedDate = Date().addingTimeInterval(86400)
    @State private var notes = ""
    @State private var isVideoCall = true
    
    let doctors = ["Dr. Sarah Johnson", "Dr. Michael Chen", "Dr. Lisa Rodriguez"]
    let specialties = ["Cardiology", "General Practice", "Dermatology", "Neurology", "Pediatrics"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Doctor")) {
                    Picker("Doctor", selection: $selectedDoctor) {
                        ForEach(doctors, id: \.self) { doctor in
                            Text(doctor)
                        }
                    }
                    .pickerStyle(DefaultPickerStyle())
                    
                    Picker("Specialty", selection: $selectedSpecialty) {
                        ForEach(specialties, id: \.self) { specialty in
                            Text(specialty)
                        }
                    }
                    .pickerStyle(DefaultPickerStyle())
                }
                
                Section(header: Text("Date & Time")) {
                    DatePicker("Date & Time", selection: $selectedDate, in: Date()...)
                }
                
                Section(header: Text("Appointment Type")) {
                    Toggle("Video Call", isOn: $isVideoCall)
                }
                
                Section(header: Text("Reason for Visit")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
                
                Section {
                    Button("Schedule Appointment") {
                        // Save the new appointment
                        presentationMode.wrappedValue.dismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.blue)
                }
            }
            .navigationTitle("Book Appointment")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// MARK: - Video Call View
struct VideoCallView: View {
    let isAI: Bool
    @Environment(\.presentationMode) var presentationMode
    @State private var isMuted = false
    @State private var isCameraOff = false
    @State private var elapsedTime = 0
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            // Video background - in a real app this would be the video feed
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            // Remote video placeholder
            VStack {
                if isAI {
                    Image(systemName: "brain")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    Text("AI Consultation")
                        .font(.title)
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    Text("Dr. Sarah Johnson")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            
            // Self view (picture-in-picture)
            VStack {
                HStack {
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray)
                            .frame(width: 100, height: 150)
                        
                        if isCameraOff {
                            Image(systemName: "video.slash.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "person.crop.rectangle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            
            // Call controls
            VStack {
                Spacer()
                
                // Timer
                Text(timeString(from: elapsedTime))
                    .font(.system(.title3, design: .monospaced))
                    .foregroundColor(.white)
                    .padding(.bottom)
                
                // Control buttons
                HStack(spacing: 30) {
                    Button(action: {
                        isMuted.toggle()
                    }) {
                        Image(systemName: isMuted ? "mic.slash.fill" : "mic.fill")
                            .font(.system(size: 25))
                            .padding()
                            .background(Color.gray.opacity(0.8))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        // End call
                        timer?.invalidate()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "phone.down.fill")
                            .font(.system(size: 25))
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        isCameraOff.toggle()
                    }) {
                        Image(systemName: isCameraOff ? "video.slash.fill" : "video.fill")
                            .font(.system(size: 25))
                            .padding()
                            .background(Color.gray.opacity(0.8))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedTime += 1
        }
    }
    
    func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Medications View
struct MedicationsView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingAddMedication = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(appState.medications) { medication in
                    MedicationRow(medication: medication)
                }
            }
            .navigationTitle("Medications")
            .navigationBarItems(trailing:
                Button(action: {
                    showingAddMedication = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showingAddMedication) {
                AddMedicationView()
            }
        }
    }
}

struct MedicationRow: View {
    let medication: Medication
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "pill.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 22))
                
                Text(medication.name)
                    .font(.headline)
                
                Spacer()
                
                if let refillDate = medication.refillDate, refillDate < Date().addingTimeInterval(604800) {
                    Text("Refill soon")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
            
            Text(medication.dosage)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(medication.instructions)
                .font(.caption)
                .foregroundColor(.secondary)
            
            if !medication.schedule.isEmpty {
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.blue)
                        .font(.system(size: 12))
                    
                    Text(scheduleText(for: medication))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 5)
    }
    
    func scheduleText(for medication: Medication) -> String {
        if medication.schedule.count == 1 {
            return "Once daily at \(timeFormatter.string(from: medication.schedule[0]))"
        } else if medication.schedule.count == 2 {
            return "Twice daily at \(medication.schedule.map { timeFormatter.string(from: $0) }.joined(separator: " and "))"
        } else {
            return "\(medication.schedule.count) times daily"
        }
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
}

struct AddMedicationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var dosage = ""
    @State private var instructions = ""
    @State private var selectedTimes: [Date] = [Date()]
    @State private var frequency = "Once Daily"
    @State private var refillDate = Date().addingTimeInterval(2592000) // 30 days
    @State private var hasRefill = true
    
    let frequencies = ["Once Daily", "Twice Daily", "Three Times Daily", "Four Times Daily", "As Needed"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Medication Details")) {
                    TextField("Medication Name", text: $name)
                    TextField("Dosage (e.g., 10mg)", text: $dosage)
                    TextField("Instructions", text: $instructions)
                }
                
                Section(header: Text("Schedule")) {
                    Picker("Frequency", selection: $frequency) {
                        ForEach(frequencies, id: \.self) { freq in
                            Text(freq)
                        }
                    }
                    .onChange(of: frequency) { newValue in
                        updateTimesBasedOnFrequency(newValue)
                    }
                    
                    if frequency != "As Needed" {
                        ForEach(0..<selectedTimes.count, id: \.self) { index in
                            DatePicker("Time \(index + 1)", selection: $selectedTimes[index], displayedComponents: .hourAndMinute)
                        }
                    }
                }
                
                Section(header: Text("Refill")) {
                    Toggle("Needs Refill", isOn: $hasRefill)
                    
                    if hasRefill {
                        DatePicker("Refill Date", selection: $refillDate, displayedComponents: .date)
                    }
                }
                
                Section {
                    Button("Save Medication") {
                        // Save the new medication
                        presentationMode.wrappedValue.dismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.blue)
                }
            }
            .navigationTitle("Add Medication")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    func updateTimesBasedOnFrequency(_ frequency: String) {
        switch frequency {
        case "Once Daily":
            selectedTimes = [Date()]
        case "Twice Daily":
            selectedTimes = [
                Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date()) ?? Date(),
                Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date()) ?? Date()
            ]
        case "Three Times Daily":
            selectedTimes = [
                Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date()) ?? Date(),
                Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date()) ?? Date(),
                Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date()) ?? Date()
            ]
        case "Four Times Daily":
            selectedTimes = [
                Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date()) ?? Date(),
                Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date()) ?? Date(),
                Calendar.current.date(bySettingHour: 16, minute: 0, second: 0, of: Date()) ?? Date(),
                Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date()) ?? Date()
            ]
        case "As Needed":
            selectedTimes = []
        default:
            selectedTimes = [Date()]
        }
    }
}

// MARK: - Vital Signs View
struct VitalSignsView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Vital signs cards
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                    ForEach(vitalSignsByType.keys.sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { type in
                        if let latestVital = vitalSignsByType[type]?.first {
                            VitalSignDetailCard(vitalSign: latestVital, history: vitalSignsByType[type] ?? [])
                        }
                    }
                }
                .padding()
                
                // Connect to wearable devices button
                Button(action: {
                    // Action to connect to wearable devices
                }) {
                    HStack {
                        Image(systemName: "applewatch")
                        Text("Connect to Apple Watch")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                // Health Reports
                VStack(alignment: .leading) {
                    Text("Health Reports")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            HealthReportCard(title: "Monthly Health Summary", date: "Mar 2025", icon: "chart.bar.fill")
                            HealthReportCard(title: "Heart Health Report", date: "Feb 2025", icon: "heart.fill")
                            HealthReportCard(title: "Sleep Analysis", date: "Jan 2025", icon: "bed.double.fill")
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Vital Signs")
        }
    }
    
    // Group vital signs by type and sort by date (newest first)
    private var vitalSignsByType: [VitalSign.VitalType: [VitalSign]] {
        Dictionary(grouping: appState.vitalSigns, by: { $0.type })
            .mapValues { values in
                values.sorted(by: { $0.timestamp > $1.timestamp })
            }
    }
}

struct VitalSignDetailCard: View {
    let vitalSign: VitalSign
    let history: [VitalSign]
    @State private var showingHistory = false
    
    var body: some View {
        Button(action: {
            showingHistory = true
        }) {
            VStack(spacing: 10) {
                Image(systemName: iconForVitalType(vitalSign.type))
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
                
                Text(vitalSign.type.rawValue)
                    .font(.headline)
                
                Text("\(Int(vitalSign.value)) \(vitalSign.unit)")
                    .font(.title2)
                    .foregroundColor(vitalSignColor(for: vitalSign))
                
                Text("Last updated: \(timeAgo(from: vitalSign.timestamp))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(height: 180)
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingHistory) {
            VitalSignHistoryView(vitalType: vitalSign.type, history: history)
        }
    }
    
    func iconForVitalType(_ type: VitalSign.VitalType) -> String {
        switch type {
        case .heartRate:
            return "heart.fill"
        case .bloodPressure:
            return "waveform.path.ecg"
        case .bloodOxygen:
            return "lungs.fill"
        case .temperature:
            return "thermometer"
        case .respiratoryRate:
            return "wind"
        }
    }
    
    func vitalSignColor(for vitalSign: VitalSign) -> Color {
        switch vitalSign.type {
        case .heartRate:
            if vitalSign.value < 60 || vitalSign.value > 100 {
                return .orange
            }
        case .bloodPressure:
            if vitalSign.value > 130 {
                return .red
            }
        case .bloodOxygen:
            if vitalSign.value < 95 {
                return .orange
            } else if vitalSign.value < 90 {
                return .red
            }
        case .temperature:
            if vitalSign.value > 99.5 {
                return .orange
            } else if vitalSign.value > 100.4 {
                return .red
            }
        case .respiratoryRate:
            if vitalSign.value < 12 || vitalSign.value > 20 {
                return .orange
            }
        }
        return .green
    }
    
    func timeAgo(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let day = components.day, day > 0 {
            return "\(day) day\(day == 1 ? "" : "s") ago"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour) hour\(hour == 1 ? "" : "s") ago"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute) minute\(minute == 1 ? "" : "s") ago"
        } else {
            return "Just now"
        }
    }
}

struct VitalSignHistoryView: View {
    let vitalType: VitalSign.VitalType
    let history: [VitalSign]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(history) { vital in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(Int(vital.value)) \(vital.unit)")
                                .font(.headline)
                            Text(dateFormatter.string(from: vital.timestamp))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // Trend indicator
                        if let previousValue = getPreviousValue(for: vital) {
                            Image(systemName: getTrendIcon(current: vital.value, previous: previousValue))
                                .foregroundColor(getTrendColor(current: vital.value, previous: previousValue))
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("\(vitalType.rawValue) History")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    func getPreviousValue(for vital: VitalSign) -> Double? {
        guard let index = history.firstIndex(where: { $0.id == vital.id }),
              index < history.count - 1 else {
            return nil
        }
        
        return history[index + 1].value
    }
    
    func getTrendIcon(current: Double, previous: Double) -> String {
        let difference = current - previous
        if abs(difference) < 0.01 {
            return "equal"
        } else if difference > 0 {
            return "arrow.up"
        } else {
            return "arrow.down"
        }
    }
    
    func getTrendColor(current: Double, previous: Double) -> Color {
        switch vitalType {
        case .heartRate, .bloodPressure, .temperature:
            // For these vitals, an increase might be concerning
            return current > previous ? .orange : .green
        case .bloodOxygen:
            // For blood oxygen, an increase is generally good
            return current > previous ? .green : .orange
        case .respiratoryRate:
            // For respiratory rate, stability is preferred
            return abs(current - previous) < 2 ? .green : .orange
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        return formatter
    }
}

struct HealthReportCard: View {
    let title: String
    let date: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(.blue)
                Spacer()
                Image(systemName: "doc.text")
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(title)
                .font(.headline)
                .lineLimit(2)
            
            Text(date)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: 170, height: 150)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

// MARK: - Nearby Hospitals View
struct NearbyHospitalsView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""
    @State private var selectedHospital: Hospital?
    
    var body: some View {
        VStack {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search hospitals", text: $searchText)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Hospitals list
            List {
                ForEach(filteredHospitals) { hospital in
                    HospitalRow(hospital: hospital)
                        .onTapGesture {
                            selectedHospital = hospital
                        }
                }
            }
            .listStyle(PlainListStyle())
            .sheet(item: $selectedHospital) { hospital in
                HospitalDetailView(hospital: hospital)
            }
        }
        .navigationTitle("Nearby Hospitals")
        .onAppear {
            // In a real app, this would get the user's current location
            let userLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
            appState.searchNearbyHospitals(location: userLocation)
        }
    }
    
    private var filteredHospitals: [Hospital] {
        if searchText.isEmpty {
            return appState.nearbyHospitals
        } else {
            return appState.nearbyHospitals.filter { hospital in
                hospital.name.lowercased().contains(searchText.lowercased()) ||
                hospital.address.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

struct HospitalRow: View {
    let hospital: Hospital
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(hospital.name)
                    .font(.headline)
                
                Text(hospital.address)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(hospital.rating) ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.system(size: 12))
                    }
                    
                    Text(String(format: "%.1f", hospital.rating))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5) {
                Text(String(format: "%.1f km", hospital.distance))
                    .font(.subheadline)
                    .foregroundColor(.blue)
                
                Button(action: {
                    // Open maps app with directions
                    let url = URL(string: "maps://?daddr=\(hospital.coordinates.latitude),\(hospital.coordinates.longitude)")
                    if let url = url, UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("Directions")
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
        }
        .padding(.vertical, 5)
    }
}

struct HospitalDetailView: View {
    let hospital: Hospital
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Map
                    Map(coordinateRegion: .constant(MKCoordinateRegion(
                        center: hospital.coordinates,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )), annotationItems: [hospital]) { hospital in
                        MapMarker(coordinate: hospital.coordinates, tint: .red)
                    }
                    .frame(height: 200)
                    .cornerRadius(10)
                    
                    // Hospital details
                    VStack(alignment: .leading, spacing: 10) {
                        Text(hospital.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        HStack {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int(hospital.rating) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                            }
                            
                            Text(String(format: "%.1f", hospital.rating))
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.red)
                            Text(hospital.address)
                        }
                        .padding(.top, 5)
                        
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.green)
                            Text(hospital.phone)
                        }
                        
                        Text("Distance: \(String(format: "%.1f km", hospital.distance))")
                            .padding(.top, 5)
                    }
                    .padding()
                    
                    // Action buttons
                    VStack(spacing: 15) {
                        Button(action: {
                            // Call hospital
                            let tel = "tel://\(hospital.phone.replacingOccurrences(of: "-", with: ""))"
                            guard let url = URL(string: tel) else { return }
                            UIApplication.shared.open(url)
                        }) {
                            HStack {
                                Image(systemName: "phone.fill")
                                Text("Call Hospital")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            // Get directions
                            let url = URL(string: "maps://?daddr=\(hospital.coordinates.latitude),\(hospital.coordinates.longitude)")
                            if let url = url, UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Image(systemName: "map.fill")
                                Text("Get Directions")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                    
                    // Services
                    VStack(alignment: .leading) {
                        Text("Services")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        Text("• Emergency Care (24/7)")
                        Text("• General Medicine")
                        Text("• Cardiology")
                        Text("• Pediatrics")
                        Text("• Orthopedics")
                        Text("• Radiology")
                        Text("• Laboratory Services")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("Hospital Details")
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// MARK: - Profile View
struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingHealthSettings = false
    @State private var showingNotificationSettings = false
    @State private var showingPrivacySettings = false
    @State private var showingAbout = false
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: appState.user?.profileImage ?? "person.crop.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(appState.user?.name ?? "User")
                                .font(.headline)
                            Text(appState.user?.email ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.leading, 5)
                    }
                    .padding(.vertical, 5)
                    
                    NavigationLink(destination: EditProfileView()) {
                        Label("Edit Profile", systemImage: "pencil")
                    }
                }
                
                Section(header: Text("Medical Information")) {
                    NavigationLink(destination: MedicalProfileView()) {
                        Label("Medical Profile", systemImage: "heart.text.square")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Label("Insurance Information", systemImage: "doc.text")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Label("Emergency Contacts", systemImage: "phone.fill")
                    }
                }
                
                Section(header: Text("Settings")) {
                    Button(action: {
                        showingHealthSettings = true
                    }) {
                        Label("Health Data Settings", systemImage: "heart.fill")
                    }
                    
                    Button(action: {
                        showingNotificationSettings = true
                    }) {
                        Label("Notifications", systemImage: "bell.fill")
                    }
                    
                    Button(action: {
                        showingPrivacySettings = true
                    }) {
                        Label("Privacy & Security", systemImage: "lock.fill")
                    }
                }
                
                Section(header: Text("About")) {
                    Button(action: {
                        showingAbout = true
                    }) {
                        Label("About MediConnect", systemImage: "info.circle")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Label("Help & Support", systemImage: "questionmark.circle")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Label("Terms of Service", systemImage: "doc.text")
                    }
                }
                
                Section {
                    Button(action: {
                        showingLogoutAlert = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Sign Out")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showingHealthSettings) {
                HealthDataSettingsView()
            }
            .sheet(isPresented: $showingNotificationSettings) {
                NotificationSettingsView()
            }
            .sheet(isPresented: $showingPrivacySettings) {
                PrivacySettingsView()
            }
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
            .alert(isPresented: $showingLogoutAlert) {
                Alert(
                    title: Text("Sign Out"),
                    message: Text("Are you sure you want to sign out?"),
                    primaryButton: .destructive(Text("Sign Out")) {
                        appState.logout()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = "555-123-4567"
    
    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                HStack {
                    Spacer()
                    
                    Image(systemName: appState.user?.profileImage ?? "person.crop.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .foregroundColor(.blue)
                    
                    Spacer()
                }
                .padding()
                
                Button("Change Photo") {
                    // Photo picker would be implemented here
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                TextField("Phone", text: $phone)
                    .keyboardType(.phonePad)
            }
            
            Section {
                Button("Save Changes") {
                    // Save changes and dismiss
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.blue)
            }
        }
        .navigationTitle("Edit Profile")
        .onAppear {
            // Load user data
            if let user = appState.user {
                name = user.name
                email = user.email
            }
        }
    }
}

struct MedicalProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var isEditing = false
    @State private var dateOfBirth = Date(timeIntervalSince1970: 0)
    @State private var bloodType = "O+"
    @State private var height = "5'10\""
    @State private var weight = "160 lbs"
    @State private var allergies = ["Peanuts", "Penicillin"]
    @State private var conditions = ["Asthma"]
    
    let bloodTypes = ["O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-"]
    
    var body: some View {
        Form {
            Section(header: Text("Basic Information")) {
                if isEditing {
                    DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                    
                    Picker("Blood Type", selection: $bloodType) {
                        ForEach(bloodTypes, id: \.self) { type in
                            Text(type)
                        }
                    }
                    
                    TextField("Height", text: $height)
                    TextField("Weight", text: $weight)
                } else {
                    HStack {
                        Text("Date of Birth")
                        Spacer()
                        Text(dateFormatter.string(from: dateOfBirth))
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Blood Type")
                        Spacer()
                        Text(bloodType)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Height")
                        Spacer()
                        Text(height)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Weight")
                        Spacer()
                        Text(weight)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Section(header: Text("Allergies")) {
                if isEditing {
                    ForEach(allergies.indices, id: \.self) { index in
                        TextField("Allergy", text: $allergies[index])
                    }
                    
                    Button("Add Allergy") {
                        allergies.append("")
                    }
                } else {
                    if allergies.isEmpty {
                        Text("No known allergies")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(allergies, id: \.self) { allergy in
                            Text(allergy)
                        }
                    }
                }
            }
            
            Section(header: Text("Medical Conditions")) {
                if isEditing {
                    ForEach(conditions.indices, id: \.self) { index in
                        TextField("Condition", text: $conditions[index])
                    }
                    
                    Button("Add Condition") {
                        conditions.append("")
                    }
                } else {
                    if conditions.isEmpty {
                        Text("No known medical conditions")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(conditions, id: \.self) { condition in
                            Text(condition)
                        }
                    }
                }
            }
        }
        .navigationTitle("Medical Profile")
        .navigationBarItems(trailing:
            Button(isEditing ? "Done" : "Edit") {
                isEditing.toggle()
            }
        )
        .onAppear {
            // Load user data
            if let user = appState.user {
                dateOfBirth = user.dateOfBirth
                bloodType = user.bloodType
                allergies = user.allergies
                conditions = user.conditions
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}

struct HealthDataSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var healthDataAccess = true
    @State private var appleHealthIntegration = true
    @State private var autoSync = true
    @State private var syncFrequency = "Hourly"
    
    let syncOptions = ["Hourly", "Every 6 Hours", "Daily", "Manual Only"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Health Data Access")) {
                    Toggle("Allow Health Data Access", isOn: $healthDataAccess)
                    Toggle("Apple Health Integration", isOn: $appleHealthIntegration)
                }
                
                Section(header: Text("Sync Settings")) {
                    Toggle("Auto Sync Data", isOn: $autoSync)
                    
                    if autoSync {
                        Picker("Sync Frequency", selection: $syncFrequency) {
                            ForEach(syncOptions, id: \.self) { option in
                                Text(option)
                            }
                        }
                    }
                    
                    Button("Sync Now") {
                        // Trigger sync
                    }
                    .disabled(!healthDataAccess)
                }
                
                Section(header: Text("Connected Devices")) {
                    NavigationLink(destination: EmptyView()) {
                        Label("Apple Watch", systemImage: "applewatch")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Label("Connect New Device", systemImage: "plus.circle")
                    }
                }
            }
            .navigationTitle("Health Data Settings")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct NotificationSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var appointmentReminders = true
    @State private var medicationReminders = true
    @State private var healthAlerts = true
    @State private var doctorMessages = true
    @State private var generalUpdates = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Allow Notifications")) {
                    Toggle("Appointment Reminders", isOn: $appointmentReminders)
                    Toggle("Medication Reminders", isOn: $medicationReminders)
                    Toggle("Health Alerts", isOn: $healthAlerts)
                    Toggle("Doctor Messages", isOn: $doctorMessages)
                    Toggle("General Updates", isOn: $generalUpdates)
                }
                
                Section(header: Text("Reminder Settings")) {
                    NavigationLink(destination: EmptyView()) {
                        Text("Appointment Reminder Timing")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Text("Medication Reminder Timing")
                    }
                }
            }
            .navigationTitle("Notifications")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct PrivacySettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var enableTwoFactor = false
    @State private var shareHealthData = true
    @State private var useBiometrics = true
    @State private var locationAccess = "While Using"
    
    let locationOptions = ["Always", "While Using", "Never"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account Security")) {
                    Toggle("Two-Factor Authentication", isOn: $enableTwoFactor)
                    Toggle("Use Face ID / Touch ID", isOn: $useBiometrics)
                    
                    NavigationLink(destination: EmptyView()) {
                        Text("Change Password")
                    }
                }
                
                Section(header: Text("Privacy")) {
                    Toggle("Share Health Data with Doctors", isOn: $shareHealthData)
                    
                    Picker("Location Access", selection: $locationAccess) {
                        ForEach(locationOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Text("Manage Permissions")
                    }
                }
                
                Section(header: Text("Data Management")) {
                    NavigationLink(destination: EmptyView()) {
                        Text("Download My Data")
                    }
                    
                    Button("Delete All Data") {
                        // Show confirmation dialog
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Privacy & Security")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Image(systemName: "heart.text.square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)
                    
                    Text("MediConnect")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Version 1.0.0")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("About MediConnect")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        Text("MediConnect is an AI-powered telemedicine application designed to provide accessible healthcare through technology. Our platform connects patients with healthcare providers and uses artificial intelligence to offer preliminary consultations and health monitoring.")
                        
                        Text("Features include AI consultations, video calls with doctors, appointment scheduling, medication management, vital sign monitoring, and emergency services.")
                        
                        Text("This application is for demonstration purposes and is not intended for actual medical use without proper certification and regulatory approval.")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    Button("Contact Support") {
                        // Open support contact options
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Text("© 2025 MediConnect Inc. All rights reserved.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top)
                }
                .padding()
            }
            .navigationTitle("About")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
