
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

// Trigger on Like
Parse.Cloud.afterSave("Like", function(request) {
  query = new Parse.Query("Product");
  query.get(request.object.get("product").id, {
    success: function(product) {
      product.increment("upvoteCount");
      product.increment("upvoteToday");
      // product.increment("scoreCurrent");
      product.save();
    },
    error: function(error) {
      console.error("Got an error " + error.code + " : " + error.message);
    }
  });
});

Parse.Cloud.afterDelete("Like", function(request) {
  query = new Parse.Query("Product");
  query.get(request.object.get("product").id, {
    success: function(product) {
      product.increment("upvoteCount", -1);
      product.increment("upvoteToday", -1);
      // product.increment("scoreCurrent", -1);
      product.save();
    },
    error: function(error) {
      console.error("Got an error " + error.code + " : " + error.message);
    }
  });
});

// Trigger on Product
Parse.Cloud.afterDelete("Product", function(request) {
  query = new Parse.Query("Like");
  query.equalTo("product", request.object);
  query.find({
    success: function(likes) {
      Parse.Object.destroyAll(likes, {
        success: function() {},
        error: function(error) {
          console.error("Error deleting related likes " + error.code + ": " + error.message);
        }
      });
    },
    error: function(error) {
      console.error("Error finding related likes " + error.code + ": " + error.message);
    }
  });
});

Parse.Cloud.beforeSave("Product", function(request, response) {
  if (request.object.get("isInReview") == true) {
    // In Review
    if(request.object.get("followers_count") > 0){
      // If the user have a lot of followers, then he can post.....
      request.object.set("isInReview", false);
    }
  }
  else {

  }
  request.object.set("scoreCurrent", request.object.get("upvoteToday")+request.object.get("scorePrevious"));
  response.success();
});

// Background job.
Parse.Cloud.job("EndOfDay", function(request, status) {
  var query = new Parse.Query("Product");
  // query.limit(400); // How to setup the limit of a query?
  // query.limit(10);
  query.each(function(product) {
      // Update to plan value passed in
      product.set("scorePrevious", product.get("scoreCurrent")*0.75-1);
      product.set("upvoteToday", 0);
      return product.save();
  }).then(function() {
    // Set the job's success status
    status.success("Migration completed successfully.");
  }, function(error) {
    // Set the job's error status
    status.error("Uh oh, something went wrong.");
  });
});