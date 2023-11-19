
String getStatusForRoute(int id,List<Map> my_requests) {
  for (var request in my_requests) {
    if (request.keys.first == id) {
      return request[id];
    }
  }
  return 'not requested'; // Default status if not found
}

class sharedData {
  List<Map> availble_routes = [
    {'driver':'Ahmed','from':'asu','to':'Nasr city','price':'50','car':'GTR','availble_seats':4,'time':'12:00','date':'1/12/2022','id':1},
    {'driver':'Abdo','from':'asu','to':'rehab','price':'20','car':'Supra','availble_seats':3,'time':'5:00','date':'5/12/2022','id':2},
    {'driver':'Ziad','from':'asu','to':'Madinaty','price':'30','car':'BMW','availble_seats':1,'time':'2:00','date':'6/12/2022','id':3},
    {'driver':'Mostafa','from':'asu','to':'New Cairo','price':'10','car':'AMG','availble_seats':2,'time':'8:00','date':'6/12/2022','id':4},
    {'driver':'Mohamed','from':'asu','to':'Roxy','price':'50','car':'Seat','availble_seats':1,'time':'16:00','date':'8/12/2022','id':5},
    {'driver':'Khaled','from':'asu','to':'rehab','price':'80','car':'Kia','availble_seats':4,'time':'16:00','date':'9/12/2022','id':6},
    {'driver':'Mahmoud','from':'asu','to':'Sherouk','price':'90','car':'Honda','availble_seats':1,'time':'12:00','date':'4/12/2022','id':7},
    {'driver':'Osos','from':'asu','to':'Old cairo','price':'20','car':'toyota','availble_seats':2,'time':'14:00','date':'10/12/2022','id':8},
    {'driver':'Ossama','from':'asu','to':'Maadi','price':'30','car':'Kia','availble_seats':3,'time':'13:00','date':'16/12/2022','id':9},
    {'driver':'Omar','from':'asu','to':'rehab','price':'60','car':'Nissan','availble_seats':2,'time':'19:00','date':'14/12/2022','id':10},
    {'driver':'Tarek','from':'asu','to':'Sherouk','price':'40','car':'Corolla','availble_seats':1,'time':'10:00','date':'16/12/2022','id':11},
    {'driver':'Hussein','from':'asu','to':'Maadi','price':'50','car':'Sunny','availble_seats':1,'time':'1:00','date':'11/3/2022','id':12},
    {'driver':'Hassan','from':'asu','to':'rehab','price':'80','car':'Skoda','availble_seats':1,'time':'2:00','date':'12/02/2022','id':13},
    {'driver':'Ahmed','from':'asu','to':'Maadi','price':'100','car':'toyota','availble_seats':2,'time':'1:00','date':'12/04/2022','id':14},
  ];
  List<Map> my_requests = [
    {1:'pending'},
    {4:'accepted'},
    {3:'pending'},
    {2:'rejected'},
  ];
  List<Map> my_finished_requests = [
    {1:'finished'},
    {4:'finished'},
    {3:'finished'},
    {2:'finished'},
  ];
}