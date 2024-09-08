import tkinter as tk
import PIL.Image
import PIL.ImageTk
import cv2


class App:
    def __init__(self, window, video_source1, video_source2, video_source3):
        self.window = window
        self.window.title("Video Processing Headquarter")
        self.video_source1 = video_source1
        self.video_source2 = video_source2
        self.video_source3 = video_source3

        # Set the window size and make it non-resizable for a clean layout
        self.window.geometry("1600x900")
        self.window.resizable(False, False)

        # Set up a futuristic gradient background
        self.window.configure(bg='#0f0f0f')

        # Create a frame for the title with a futuristic font and style
        title_frame = tk.Frame(window, bg="#1f1f1f", pady=20)
        title_frame.pack(fill="x")

        title_label = tk.Label(
            title_frame, 
            text="Video Processing Headquarter", 
            font=("Helvetica", 36, "bold"), 
            fg="#00ffcc", 
            bg="#1f1f1f"
        )
        title_label.pack()

        # Create a frame for the video canvases with a sleek border
        video_frame = tk.Frame(window, bg="#0f0f0f", padx=20, pady=20)
        video_frame.pack()

        # Open video sources
        self.vid1 = MyVideoCapture(self.video_source1, self.video_source2, self.video_source3)

        # Create video canvases with a neon-like border effect
        self.canvas1 = tk.Canvas(video_frame, width=500, height=500, bd=0, highlightthickness=2, highlightbackground="#00ffcc")
        self.canvas2 = tk.Canvas(video_frame, width=500, height=500, bd=0, highlightthickness=2, highlightbackground="#ff00cc")
        self.canvas3 = tk.Canvas(video_frame, width=500, height=500, bd=0, highlightthickness=2, highlightbackground="#00ccff")

        self.canvas1.grid(row=0, column=0, padx=20, pady=10)
        self.canvas2.grid(row=0, column=1, padx=20, pady=10)
        self.canvas3.grid(row=0, column=2, padx=20, pady=10)

        # Set up a delay for video updates
        self.delay = 15
        self.update()

        self.window.mainloop()

    def update(self):
        # Get frames from the video sources
        ret1, frame1, ret2, frame2, ret3, frame3 = self.vid1.get_frame

        if ret1 and ret2 and ret3:
            self.photo1 = PIL.ImageTk.PhotoImage(image=PIL.Image.fromarray(frame1))
            self.photo2 = PIL.ImageTk.PhotoImage(image=PIL.Image.fromarray(frame2))
            self.photo3 = PIL.ImageTk.PhotoImage(image=PIL.Image.fromarray(frame3))

            self.canvas1.create_image(0, 0, image=self.photo1, anchor=tk.NW)
            self.canvas2.create_image(0, 0, image=self.photo2, anchor=tk.NW)
            self.canvas3.create_image(0, 0, image=self.photo3, anchor=tk.NW)

        self.window.after(self.delay, self.update)


class MyVideoCapture:
    def __init__(self, video_source1, video_source2, video_source3):
        # Open the video sources
        self.vid1 = cv2.VideoCapture(video_source1)
        self.vid2 = cv2.VideoCapture(video_source2)
        self.vid3 = cv2.VideoCapture(video_source3)

        if not self.vid1.isOpened():
            raise ValueError("Unable to open video source", video_source1)
        if not self.vid2.isOpened():
            raise ValueError("Unable to open video source", video_source2)
        if not self.vid3.isOpened():
            raise ValueError("Unable to open video source", video_source3)

    @property
    def get_frame(self):
        ret1 = ret2 = ret3 = ""
        if self.vid1.isOpened() and self.vid2.isOpened() and self.vid3.isOpened():
            ret1, frame1 = self.vid1.read()
            ret2, frame2 = self.vid2.read()
            ret3, frame3 = self.vid3.read()

            frame1 = cv2.resize(frame1, (500, 500))
            frame2 = cv2.resize(frame2, (500, 500))
            frame3 = cv2.resize(frame3, (500, 500))

            if ret1 and ret2 and ret3:
                return (
                    ret1, cv2.cvtColor(frame1, cv2.COLOR_BGR2RGB),
                    ret2, cv2.cvtColor(frame2, cv2.COLOR_BGR2RGB),
                    ret3, cv2.cvtColor(frame3, cv2.COLOR_BGR2RGB)
                )
            else:
                return ret1, None, ret2, None, ret3, None
        else:
            return ret1, None, ret2, None, ret3, None

    # Release the video source when the object is destroyed
    def __del__(self):
        if self.vid1.isOpened():
            self.vid1.release()
        if self.vid2.isOpened():
            self.vid2.release()
        if self.vid3.isOpened():
            self.vid3.release()


def callback():
    global v1, v2, v3
    v1 = E1.get()
    v2 = E2.get()
    v3 = E3.get()
    if v1 == "" or v2 == "" or v3 == "":
        L4.pack()
        return
    initial.destroy()


v1 = ""
v2 = ""
v3 = ""

# Initial input window to get video paths
initial = tk.Tk()
initial.title("KEC MEDIA PLAYER")
initial.configure(bg="#0f0f0f")
L0 = tk.Label(initial, text="Enter the full path", fg="#00ffcc", bg="#0f0f0f", font=("Helvetica", 14))
L0.pack(pady=10)
L1 = tk.Label(initial, text="Video 1", fg="#00ffcc", bg="#0f0f0f", font=("Helvetica", 12))
L1.pack()
E1 = tk.Entry(initial, bd=2, bg="#1f1f1f", fg="#00ffcc", insertbackground="#00ffcc", font=("Helvetica", 12))
E1.pack(pady=5)
L2 = tk.Label(initial, text="Video 2", fg="#00ffcc", bg="#0f0f0f", font=("Helvetica", 12))
L2.pack()
E2 = tk.Entry(initial, bd=2, bg="#1f1f1f", fg="#00ffcc", insertbackground="#00ffcc", font=("Helvetica", 12))
E2.pack(pady=5)
L3 = tk.Label(initial, text="Video 3", fg="#00ffcc", bg="#0f0f0f", font=("Helvetica", 12))
L3.pack()
E3 = tk.Entry(initial, bd=2, bg="#1f1f1f", fg="#00ffcc", insertbackground="#00ffcc", font=("Helvetica", 12))
E3.pack(pady=5)
B = tk.Button(initial, text="Next", command=callback, bg="#1f1f1f", fg="#00ffcc", font=("Helvetica", 12))
B.pack(pady=10)
L4 = tk.Label(initial, text="Enter all video paths", fg="#ff0066", bg="#0f0f0f", font=("Helvetica", 12))

initial.mainloop()

# Create a window and pass it to the Application object
App(tk.Tk(), v1, v2, v3)
