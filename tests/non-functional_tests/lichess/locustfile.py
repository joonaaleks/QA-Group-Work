from locust import HttpUser, task, between

class User(HttpUser):
    wait_time = between(1, 5)
    host = "http://localhost:8080"

    @task(1)
    def home(self):
        self.client.get("/")
    
    @task(2)
    def analysis(self):
        self.client.get("/analysis")

    @task(2)
    def training(self):
        self.client.get("/training")

    @task(1)
    def profile(self):
        self.client.get("/@/lichess")
