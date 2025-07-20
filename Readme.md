# MAARG: A Core ML Trail Guide 🌲

Hey there, and welcome! 👋

This project is more than just an app; it's a personal journey I undertook to deepen my skills in modern iOS development. I wanted to build something feature-rich and challenging from the ground up, pushing myself to learn and master the frameworks that power today's best applications.

My goal was to create a beautiful, functional, and intelligent companion for outdoor adventures, and every feature you see is a testament to that learning process.

***

## 🚀 A Deep Dive into the Features & Technology

I chose a modern, powerful tech stack to bring this project to life. Here’s a detailed breakdown of the key frameworks I used and the role each one plays in the app.

### 👨‍💻 Swift
The entire application is written in **Swift**, a modern, powerful, and intuitive programming language. Its emphasis on safety and speed is essential for building a high-performance, reliable app. Its clean syntax and expressive features allowed me to write clear, understandable code, which made the entire development process more efficient and enjoyable.

### 🎨 SwiftUI
The entire user interface is built declaratively with **SwiftUI**, which provides a modern, intuitive approach to building complex UIs that look great on any Apple device. From the main tab views and smooth screen transitions to the detailed data cards, SwiftUI allowed me to write clean, reusable, and state-driven code. The UI is also fully adaptive, ensuring a great experience on both iPhone and iPad, and supports features like **Dark Mode** right out of the box.

### 🗺️ MapKit
For all the geographic features, I integrated **MapKit**. This is the heart of the trail experience. It's used to:
* **Display interactive maps** where users can see their current location in real-time.
* **Plot and draw trail routes** with custom line styles and colors.
* **Add custom annotations** to mark points of interest, like a scenic viewpoint, a water source, or the trailhead.
* **Dynamically update the camera** to follow the user's path and heading, creating an immersive navigation experience.

### ❤️ HealthKit
To create a truly personal fitness experience, I used **HealthKit** to securely access the user's health data (with their permission, of course!). When a user tracks an activity, the app requests access to workout-specific metrics like:
* Active energy burned (calories)
* Heart rate data throughout the activity
* Distance traveled and steps taken
This data is then linked to the specific trail activity, allowing users to see a complete picture of their workout in the context of their adventure.

### 🏗️ Create ML
Before the app could be intelligent, a model had to be born. I used **Create ML**, a user-friendly framework for training machine learning models. I fed it a curated dataset of trail information to teach it how to recognize specific patterns. This tool allowed me to focus on the data and the training process without getting bogged down in complex machine learning code, making it perfect for building custom, task-specific models.

### 🧠 Core ML & The On-Device Model
The "brains" of the app come from **Core ML**. This framework takes the model I built with Create ML and runs it directly and efficiently on the device.
* **What the model does:** It was trained to analyze key characteristics of a trail—like elevation change, distance, and user-provided tags—to predict its **difficulty level** (e.g., Easy, Moderate, Hard).
* **Why it's on-device:** By running the model locally, the app provides instant analysis without needing an internet connection, which is crucial for a tool meant for the outdoors.

### 🗄️ SwiftData
For all data persistence, I chose this newest framework, **SwiftData**. It serves as the powerful **on-device database** for the app. It handles everything from saved trail routes and workout history to user notes and photos pinned to a location. I used it because of its incredible simplicity and seamless integration with SwiftUI. All data is saved securely on the user's device, ensuring it's always available and lightning-fast to access.

***

## 📸 A Glimpse of the Adventure

Here are a few snapshots of what this project looks like in action. This is where the code meets the real world!


<table align="center">
 <tr>
  <td align="center"><strong>AI-Powered Difficulty Prediction</strong></td>
  <td align="center"><strong>HealthKit Data & Permissions</strong></td>
 </tr>
 <tr>
  <td><img src="https://github.com/divyadeepmishra/MAARG/blob/main/assets/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-07-19%20at%2010.32.35.png" alt="A screenshot showing the main user interface of the app." width="350"></td>
  <td><img src="https://github.com/divyadeepmishra/MAARG/blob/main/assets/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-07-19%20at%2010.14.31.png" alt="A screenshot showing the machine learning model identifying a feature on a trail." width="350"></td>
 </tr>
 <tr>
  <td align="center"><strong>Live Map & Route Tracking</strong></td>
  <td align="center"><strong>SwiftUI-Based User Input</strong></td>
 </tr>
  <tr>
  <td><img src="https://github.com/divyadeepmishra/MAARG/blob/main/assets/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-07-19%20at%2010.32.07.png" alt="A beautiful photo of a trail that the app might analyze." width="350"></td>
  <td><img src="https://github.com/divyadeepmishra/MAARG/blob/main/assets/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-07-19%20at%2010.32.19.png" alt="A screenshot of another feature within the app." width="350"></td>
 </tr>
</table>

  *[Click here to watch the full MAARG app demonstration on YouTube.](https://youtube.com/shorts/cUqQEj2Knwo)*

***

## 🔎 How to Explore This Repo

Ready to dive in? Here’s a quick guide to what’s where:

* **/MAARG/**: This is where the magic happens! All the Swift code and app logic lives here.
* **`TrailAnalyzerModel.mlmodel`**: The little brain of my operation. You can even click on it in Xcode to see details about the model.
* **`.gitignore`**: The guardian file that keeps the repository clean.
* **`README.md`**: You're reading it right now! 😊

To get started, just clone this repository, open the `.xcodeproj` or `.xcworkspace` file in Xcode, and hit "Build & Run".

---

I built this project with the goal of growing as a developer. I hope you enjoy exploring the code and seeing how these powerful frameworks come together. Feel free to raise an issue, suggest a new idea, or even fork the project to start your own adventure!


Happy Learning! 🏞️

