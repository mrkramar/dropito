from django.db import models

class Post(models.Model):
    text = models.TextField()
    timestamp = models.TextField()
    image = models.TextField(blank=True)
    author = models.TextField()
    lat = models.FloatField()
    lon = models.FloatField()
    location = models.TextField()

class User(models.Model):
    username = models.CharField(max_length=20, unique=True)
    avatar = models.TextField(blank=True)

class Comment(models.Model):
    post = models.IntegerField()
    text = models.TextField()
    timestamp = models.TextField()
    author = models.TextField()

class Conversation(models.Model):
    user1 = models.CharField(max_length=20)
    user2 = models.CharField(max_length=20)
    last_message = models.TextField()
    last_timestamp = models.TextField()

class Message(models.Model):
    text = models.TextField()
    #conversation = models.ForeignKey(Conversation, on_delete=models.CASCADE)
    timestamp = models.TextField()
