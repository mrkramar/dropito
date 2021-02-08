from tastypie.resources import ModelResource
from tastypie.authorization import Authorization
from api.models import Post, User, Comment
from tastypie.resources import ModelResource, ALL, ALL_WITH_RELATIONS

class PostResource(ModelResource):
    class Meta:
        queryset = Post.objects.all()
        resource_name = 'post'
        authorization = Authorization()
        filtering = {'lat': ALL, 'lon': ALL, 'author': ALL}

class CommentResource(ModelResource):
    class Meta:
        queryset = Comment.objects.all()
        resource_name = 'comment'
        authorization = Authorization()
        filtering = {'post': ALL}
  
class UserResource(ModelResource):
    class Meta:
        queryset = User.objects.all()
        resource_name = 'user'
        authorization = Authorization()
        #filtering = {'username': ALL}
      