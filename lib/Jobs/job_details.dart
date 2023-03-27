import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';
import 'package:we_work_app/Jobs/jobs_screen.dart';
import 'package:we_work_app/Services/global_methods.dart';
import 'package:we_work_app/Services/global_variables.dart';

class JobDetails extends StatefulWidget {
  final String uploadedBy;
  final String jobID;

  const JobDetails({required this.uploadedBy, required this.jobID});

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  bool _isCommenting = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _commentController = TextEditingController();

  String? authorName;
  String? userImageUrl;
  String? jobCategory;
  String? jobDescription;
  String? jobTitle;
  bool? recruitment;
  Timestamp? postedDateTimeStamp;
  Timestamp? jobLengthTimeStamp;
  String? postedDate;
  String? jobLengthDate;
  String? locationCompany = '';
  String? emailCompany = '';
  int applicants = 0;
  bool isJobLengthAvailable = false;
  bool showComment = false;

  void getJobData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uploadedBy)
        .get();

    if (userDoc == null) {
      return;
    } else {
      setState(() {
        authorName = userDoc.get('name');
        userImageUrl = userDoc.get('userImage');
      });
    }
    final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.jobID)
        .get();
    if (jobDatabase == null) {
      return;
    } else {
      setState(() {
        jobTitle = jobDatabase.get('jobTitle');
        jobDescription = jobDatabase.get('jobDescription');
        recruitment = jobDatabase.get('recruitment');
        emailCompany = jobDatabase.get('email');
        locationCompany = jobDatabase.get('location');
        applicants = jobDatabase.get('applicants');
        postedDateTimeStamp = jobDatabase.get('createdAt');
        jobLengthTimeStamp = jobDatabase.get('jobLengthTimeStamp');
        jobLengthDate = jobDatabase.get('jobLength');
        var postDate = postedDateTimeStamp!.toDate();
        postedDate = '${postDate.month} / ${postDate.day} / ${postDate.year}';
      });

      var date = jobLengthTimeStamp!.toDate();
      isJobLengthAvailable = date.isAfter(DateTime.now());
    }
  }

  @override
  void initState() {
    super.initState();
    getJobData();
  }

  Widget dividerWidget() {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Colors.deepOrange.shade300, Colors.green.shade300],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Column(
        children: const [
          SizedBox(
            height: 10,
          ),
          Divider(
            thickness: 1,
            color: Colors.white,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  applyForJob() {
    final Uri params = Uri(
      scheme: 'mailto',
      path: emailCompany,
      query:
          'subject=Applying for $jobTitle&body=Hello, please attach Resume CV',
    );
    final url = params.toString();
    launchUrlString(url);
    addNewApplicant();
  }

  void addNewApplicant() async {
    var docRef =
        FirebaseFirestore.instance.collection('jobs').doc(widget.jobID);

    docRef.update({'applicants': applicants + 1});

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange.shade300, Colors.green.shade300],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.2, 0.9],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 40,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => JobScreen()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                color: Colors.black54,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          jobTitle == null ? '' : jobTitle!,
                          maxLines: 3,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: Colors.grey,
                                ),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    userImageUrl == null
                                        ? 'https://cdn.vectorstock.com/i/preview-1x/54/28/headshot-line-icon-avatar-placeholder-sign-vector-46445428.jpg'
                                        : userImageUrl!,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authorName == null ? '' : authorName!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    locationCompany!,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      dividerWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            applicants.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          const Text(
                            'Applicants',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                Colors.deepOrange.shade300,
                                Colors.green.shade300
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: const Icon(
                              Icons.how_to_reg_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      FirebaseAuth.instance.currentUser!.uid !=
                              widget.uploadedBy
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                dividerWidget(),
                                const Text(
                                  'Recruitment',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        User? user = _auth.currentUser;
                                        final _uid = user!.uid;
                                        if (_uid == widget.uploadedBy) {
                                          try {
                                            FirebaseFirestore.instance
                                                .collection('jobs')
                                                .doc(widget.jobID)
                                                .update({'recruitment': true});
                                          } catch (error) {
                                            GlobalMethod.showErrorDialog(
                                                error:
                                                    "Action can't be performed",
                                                ctx: context);
                                          }
                                        } else {
                                          GlobalMethod.showErrorDialog(
                                            error:
                                                "You can't perform this action",
                                            ctx: context,
                                          );
                                        }
                                        getJobData();
                                      },
                                      child: ShaderMask(
                                        shaderCallback: (bounds) =>
                                            LinearGradient(
                                          colors: [
                                            Colors.deepOrange.shade300,
                                            Colors.green.shade300
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ).createShader(bounds),
                                        child: const Text(
                                          'ON',
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Opacity(
                                      opacity: recruitment == true ? 1 : 0,
                                      child: const Icon(
                                        Icons.check_box_rounded,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 40,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        User? user = _auth.currentUser;
                                        final _uid = user!.uid;
                                        if (_uid == widget.uploadedBy) {
                                          try {
                                            FirebaseFirestore.instance
                                                .collection('jobs')
                                                .doc(widget.jobID)
                                                .update({'recruitment': false});
                                          } catch (error) {
                                            GlobalMethod.showErrorDialog(
                                                error:
                                                    "Action can't be performed",
                                                ctx: context);
                                          }
                                        } else {
                                          GlobalMethod.showErrorDialog(
                                            error:
                                                "You can't perform this action",
                                            ctx: context,
                                          );
                                        }
                                        getJobData();
                                      },
                                      child: ShaderMask(
                                        shaderCallback: (bounds) =>
                                            LinearGradient(
                                          colors: [
                                            Colors.deepOrange.shade300,
                                            Colors.green.shade300
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ).createShader(bounds),
                                        child: const Text(
                                          'OFF',
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Opacity(
                                      opacity: recruitment == false ? 1 : 0,
                                      child: const Icon(
                                        Icons.check_box_rounded,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      dividerWidget(),
                      const Text(
                        'Job Description',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        jobDescription == null ? '' : jobDescription!,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                      dividerWidget(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                color: Colors.black54,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          isJobLengthAvailable
                              ? 'Actively Recruiting, Send CV/Resume:'
                              : 'Job Length Passed.',
                          style: TextStyle(
                            color: isJobLengthAvailable
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Colors.deepOrange.shade300,
                              Colors.green.shade300
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: MaterialButton(
                            onPressed: () {
                              applyForJob();
                            },
                            color: Colors.white,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text(
                                'Easy Apply Now',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      dividerWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Uploaded on:',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            postedDate == null ? '' : postedDate!,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Job Length:',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            jobLengthDate == null ? '' : jobLengthDate!,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                      dividerWidget(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                color: Colors.black54,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                        child: _isCommenting
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: TextField(
                                      controller: _commentController,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      maxLength: 200,
                                      keyboardType: TextInputType.text,
                                      maxLines: 6,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: ShaderMask(
                                            shaderCallback: (bounds) =>
                                                const LinearGradient(
                                              colors: [
                                                Colors.orange,
                                                Colors.green
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ).createShader(bounds),
                                            child: MaterialButton(
                                              onPressed: () async {
                                                if (_commentController
                                                        .text.length <
                                                    7) {
                                                  GlobalMethod.showErrorDialog(
                                                    error:
                                                        "Comment can't be less than 7 characters",
                                                    ctx: context,
                                                  );
                                                } else {
                                                  final _generatedId =
                                                      const Uuid().v4();
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('jobs')
                                                      .doc(widget.jobID)
                                                      .update({
                                                    'jobComments':
                                                        FieldValue.arrayUnion([
                                                      {
                                                        'userId': FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid,
                                                        'commentId':
                                                            _generatedId,
                                                        'name': name,
                                                        'userImageUrl':
                                                            userImage,
                                                        'commentBody':
                                                            _commentController
                                                                .text,
                                                        'time': Timestamp.now(),
                                                      }
                                                    ]),
                                                  });
                                                  await Fluttertoast.showToast(
                                                    msg:
                                                        'Your comment has been posted',
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    fontSize: 18.0,
                                                  );
                                                  _commentController.clear();
                                                }
                                                setState(() {
                                                  showComment = true;
                                                });
                                              },
                                              color: Colors.white,
                                              elevation: 10,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Text(
                                                'Post',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _isCommenting = !_isCommenting;
                                              showComment = false;
                                            });
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
                                      colors: [Colors.orange, Colors.green],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(bounds),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isCommenting = !_isCommenting;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.add_comment_rounded,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
                                      colors: [Colors.orange, Colors.green],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(bounds),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showComment = false;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.arrow_drop_down_circle_rounded,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
