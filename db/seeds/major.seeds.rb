require File.expand_path("../../../config/environment", __FILE__)

f0 = User::Faculty.new
f0.order = 1
I18n.locale = :en
f0.name = "Please Scroll Down" 
I18n.locale = :zh_HK
f0.name = "請往下看"

f0m1 = f0.major.new
f0m1.code = "0"
I18n.locale = :en
f0m1.name = "N/A" 
I18n.locale = :zh_HK
f0m1.name = "不適用"
f0m1.save

f0m2 = f0.major.new
f0m2.code = "MASTER"
I18n.locale = :en
f0m2.name = "Master's Programme" 
I18n.locale = :zh_HK
f0m2.name = "碩士課程"
f0m2.save

f0m3 = f0.major.new
f0m3.code = "DOCTOR"
I18n.locale = :en
f0m3.name = "Doctoral Programme" 
I18n.locale = :zh_HK
f0m3.name = "博士課程"
f0m3.save

f0m4 = f0.major.new
f0m4.code = "OTHER"
I18n.locale = :en
f0m4.name = "Other Programme" 
I18n.locale = :zh_HK
f0m4.name = "其他課程"
f0m4.save

f0.save

f1 = User::Faculty.new
f1.order = 2
I18n.locale = :en
f1.name = "Faculty of Arts" 
I18n.locale = :zh_HK
f1.name = "文學院"

f1m1 = f1.major.new
f1m1.code = "ANTH"
I18n.locale = :en
f1m1.name = "Anthropology" 
I18n.locale = :zh_HK
f1m1.name = "人類學"
f1m1.save

f1m2 = f1.major.new
f1m2.code = "CHLL"
I18n.locale = :en
f1m2.name = "Chinese Language and Literature" 
I18n.locale = :zh_HK
f1m2.name = "中國語言及文學"
f1m2.save

f1m3 = f1.major.new
f1m3.code = "CULS"
I18n.locale = :en
f1m3.name = "Cultural Studies" 
I18n.locale = :zh_HK
f1m3.name = "文化研究"
f1m3.save

f1m4 = f1.major.new
f1m4.code = "CUMS"
I18n.locale = :en
f1m4.name = "Cultural Management(2-year programme)" 
I18n.locale = :zh_HK
f1m4.name = "文化管理(兩年制課程)"
f1m4.save

f1m5 = f1.major.new
f1m5.code = "CUMT"
I18n.locale = :en
f1m5.name = "Cultural Management" 
I18n.locale = :zh_HK
f1m5.name = "文化管理"
f1m5.save

f1m6 = f1.major.new
f1m6.code = "ENGE"
I18n.locale = :en
f1m6.name = "English" 
I18n.locale = :zh_HK
f1m6.name = "英文"
f1m6.save

f1m7 = f1.major.new
f1m7.code = "FAAS"
I18n.locale = :en
f1m7.name = "Fine Arts" 
I18n.locale = :zh_HK
f1m7.name = "藝術"
f1m7.save

f1m8 = f1.major.new
f1m8.code = "HIST"
I18n.locale = :en
f1m8.name = "History" 
I18n.locale = :zh_HK
f1m8.name = "歷史"
f1m8.save

f1m9 = f1.major.new
f1m9.code = "JASP"
I18n.locale = :en
f1m9.name = "Japanese Studies" 
I18n.locale = :zh_HK
f1m9.name = "日本研究"
f1m9.save

f1m10 = f1.major.new
f1m10.code = "LING"
I18n.locale = :en
f1m10.name = "Linguistics" 
I18n.locale = :zh_HK
f1m10.name = "語言學"
f1m10.save

f1m11 = f1.major.new
f1m11.code = "MUSC"
I18n.locale = :en
f1m11.name = "Music" 
I18n.locale = :zh_HK
f1m11.name = "音樂"
f1m11.save

f1m12 = f1.major.new
f1m12.code = "PHIL"
I18n.locale = :en
f1m12.name = "Philosophy" 
I18n.locale = :zh_HK
f1m12.name = "哲學"
f1m12.save

f1m13 = f1.major.new
f1m13.code = "RELS"
I18n.locale = :en
f1m13.name = "Religious Studies" 
I18n.locale = :zh_HK
f1m13.name = "宗教研究"
f1m13.save

f1m14 = f1.major.new
f1m14.code = "THEO"
I18n.locale = :en
f1m14.name = "Theology" 
I18n.locale = :zh_HK
f1m14.name = "神學"
f1m14.save

f1m15 = f1.major.new
f1m15.code = "TRAN"
I18n.locale = :en
f1m15.name = "Translation" 
I18n.locale = :zh_HK
f1m15.name = "翻譯"
f1m15.save

f1.save

f2 = User::Faculty.new
f2.order = 3
I18n.locale = :en
f2.name = "Faculty of Business Administration" 
I18n.locale = :zh_HK
f2.name = "工商管理學院"

f2m1 = f2.major.new
f2m1.code = "BBBA"
I18n.locale = :en
f2m1.name = "Insurance, Financial and Actuarial Analysis / Quantitative Finance(Broad-based Admission)" 
I18n.locale = :zh_HK
f2m1.name = "保險、金融與精算學/ 計量金融學(大類招生)"
f2m1.save

f2m2 = f2.major.new
f2m2.code = "HTMG"
I18n.locale = :en
f2m2.name = "Hotel and Tourism Management" 
I18n.locale = :zh_HK
f2m2.name = "酒店及旅遊管理學"
f2m2.save

f2m3 = f2.major.new
f2m3.code = "IBBA"
I18n.locale = :en
f2m3.name = "Integrated BBA Programme" 
I18n.locale = :zh_HK
f2m3.name = "工商管理學士綜合課程"
f2m3.save

f2m4 = f2.major.new
f2m4.code = "PACC"
I18n.locale = :en
f2m4.name = "Professional Accountancy" 
I18n.locale = :zh_HK
f2m4.name = "專業會計學"
f2m4.save

f2.save

f3 = User::Faculty.new
f3.order = 4
I18n.locale = :en
f3.name = "Faculty of Education" 
I18n.locale = :zh_HK
f3.name = "教育學院"

f3m1 = f3.major.new
f3m1.code = "BMED"
I18n.locale = :en
f3m1.name = "Mathematics and Mathematics Education" 
I18n.locale = :zh_HK
f3m1.name = "數學及數學教育"
f3m1.save

f3m2 = f3.major.new
f3m2.code = "CLED"
I18n.locale = :en
f3m2.name = "Chinese Language Studies and Chinese Language Education" 
I18n.locale = :zh_HK
f3m2.name = "中國語文研究及中國語文教育"
f3m2.save

f3m3 = f3.major.new
f3m3.code = "ELED"
I18n.locale = :en
f3m3.name = "English Studies and English Language Education" 
I18n.locale = :zh_HK
f3m3.name = "英國語文研究及英國語文教育"
f3m3.save

f3m4 = f3.major.new
f3m4.code = "ESHE"
I18n.locale = :en
f3m4.name = "Exercise Science and Health Education" 
I18n.locale = :zh_HK
f3m4.name = "運動科學與健康教育"
f3m4.save

f3m5 = f3.major.new
f3m5.code = "LSED"
I18n.locale = :en
f3m5.name = "Liberal Studies" 
I18n.locale = :zh_HK
f3m5.name = "通識教育"
f3m5.save

f3m6 = f3.major.new
f3m6.code = "PESH"
I18n.locale = :en
f3m6.name = "Physical Education, Exercise Science and Health" 
I18n.locale = :zh_HK
f3m6.name = "健康與體育運動科學"
f3m6.save

f3.save

f4 = User::Faculty.new
f4.order = 5
I18n.locale = :en
f4.name = "Faculty of Engineering" 
I18n.locale = :zh_HK
f4.name = "工程學院"

f4m1 = f4.major.new
f4m1.code = "BERG"
I18n.locale = :en
f4m1.name = "Engineering(Broad-based Admission)" 
I18n.locale = :zh_HK
f4m1.name = "工程學院(大類招生)"
f4m1.save

f4m2 = f4.major.new
f4m2.code = "BMEG"
I18n.locale = :en
f4m2.name = "Biomedical Engineering" 
I18n.locale = :zh_HK
f4m2.name = "生物醫學工程學"
f4m2.save

f4m3 = f4.major.new
f4m3.code = "CENG"
I18n.locale = :en
f4m3.name = "Computer Engineering" 
I18n.locale = :zh_HK
f4m3.name = "計算機工程學"
f4m3.save

f4m4 = f4.major.new
f4m4.code = "CSCI"
I18n.locale = :en
f4m4.name = "Computer Science" 
I18n.locale = :zh_HK
f4m4.name = "計算機科學"
f4m4.save

f4m5 = f4.major.new
f4m5.code = "ELEG"
I18n.locale = :en
f4m5.name = "Electronic Engineering" 
I18n.locale = :zh_HK
f4m5.name = "電子工程學"
f4m5.save

f4m6 = f4.major.new
f4m6.code = "ENER"
I18n.locale = :en
f4m6.name = "Energy Engineering" 
I18n.locale = :zh_HK
f4m6.name = "能源工程學"
f4m6.save

f4m7 = f4.major.new
f4m7.code = "IERG"
I18n.locale = :en
f4m7.name = "Information Engineering" 
I18n.locale = :zh_HK
f4m7.name = "信息工程學"
f4m7.save

f4m8 = f4.major.new
f4m8.code = "MAEG"
I18n.locale = :en
f4m8.name = "Mechanical and Automation Engineering" 
I18n.locale = :zh_HK
f4m8.name = "機械與自動化工程學"
f4m8.save

f4m9 = f4.major.new
f4m9.code = "SEEM"
I18n.locale = :en
f4m9.name = "Systems Engineering and Engineering Management" 
I18n.locale = :zh_HK
f4m9.name = "系統工程與工程管理學"
f4m9.save

f4.save

f5 = User::Faculty.new
f5.order = 6
I18n.locale = :en
f5.name = "Faculty of Law" 
I18n.locale = :zh_HK
f5.name = "法律學院"

f5m1 = f5.major.new
f5m1.code = "LAWS"
I18n.locale = :en
f5m1.name = "LLB" 
I18n.locale = :zh_HK
f5m1.name = "法學士課程"
f5m1.save

f5.save

f6 = User::Faculty.new
f6.order = 7
I18n.locale = :en
f6.name = "Faculty of Medicine" 
I18n.locale = :zh_HK
f6.name = "醫學院"

f6m1 = f6.major.new
f6m1.code = "CHPR"
I18n.locale = :en
f6m1.name = "Community Health Practice" 
I18n.locale = :zh_HK
f6m1.name = "社區健康"
f6m1.save

f6m2 = f6.major.new
f6m2.code = "BCME"
I18n.locale = :en
f6m2.name = "Chinese Medicine" 
I18n.locale = :zh_HK
f6m2.name = "中醫學"
f6m2.save

f6m3 = f6.major.new
f6m3.code = "BSCG"
I18n.locale = :en
f6m3.name = "Gerontology" 
I18n.locale = :zh_HK
f6m3.name = "老年學"
f6m3.save

f6m4 = f6.major.new
f6m4.code = "MEDU"
I18n.locale = :en
f6m4.name = "M.B., Ch.B." 
I18n.locale = :zh_HK
f6m4.name = "內外全科醫學士課程"
f6m4.save

f6m5 = f6.major.new
f6m5.code = "NURS"
I18n.locale = :en
f6m5.name = "Nursing" 
I18n.locale = :zh_HK
f6m5.name = "護理學"
f6m5.save

f6m6 = f6.major.new
f6m6.code = "PHAR"
I18n.locale = :en
f6m6.name = "Pharmacy" 
I18n.locale = :zh_HK
f6m6.name = "藥劑學"
f6m6.save

f6m7 = f6.major.new
f6m7.code = "PHPC"
I18n.locale = :en
f6m7.name = "Public Health" 
I18n.locale = :zh_HK
f6m7.name = "公共衞生學"
f6m7.save

f6.save

f7 = User::Faculty.new
f7.order = 8
I18n.locale = :en
f7.name = "Faculty of Science" 
I18n.locale = :zh_HK
f7.name = "理學院"

f7m1 = f7.major.new
f7m1.code = "BSCI"
I18n.locale = :en
f7m1.name = "Science(Broad-based Admission)" 
I18n.locale = :zh_HK
f7m1.name = "理學院(大類招生)"
f7m1.save

f7m2 = f7.major.new
f7m2.code = "BCHE"
I18n.locale = :en
f7m2.name = "Biochemistry" 
I18n.locale = :zh_HK
f7m2.name = "生物化學"
f7m2.save

f7m3 = f7.major.new
f7m3.code = "BIOL"
I18n.locale = :en
f7m3.name = "Biology" 
I18n.locale = :zh_HK
f7m3.name = "生物學"
f7m3.save

f7m4 = f7.major.new
f7m4.code = "CMBI"
I18n.locale = :en
f7m4.name = "Cell and Molecular Biology" 
I18n.locale = :zh_HK
f7m4.name = "細胞及分子生物學"
f7m4.save

f7m5 = f7.major.new
f7m5.code = "CHEM"
I18n.locale = :en
f7m5.name = "Chemistry" 
I18n.locale = :zh_HK
f7m5.name = "化學"
f7m5.save

f7m6 = f7.major.new
f7m6.code = "ENSC"
I18n.locale = :en
f7m6.name = "Environmental Science" 
I18n.locale = :zh_HK
f7m6.name = "環境科學"
f7m6.save

f7m7 = f7.major.new
f7m7.code = "FNSC"
I18n.locale = :en
f7m7.name = "Food and Nutritional Sciences" 
I18n.locale = :zh_HK
f7m7.name = "食品及營養科學"
f7m7.save

f7m8 = f7.major.new
f7m8.code = "ESSC"
I18n.locale = :en
f7m8.name = "Earth System Science" 
I18n.locale = :zh_HK
f7m8.name = "地球系統科學"
f7m8.save

f7m9 = f7.major.new
f7m9.code = "MATH"
I18n.locale = :en
f7m9.name = "Mathematics" 
I18n.locale = :zh_HK
f7m9.name = "數學"
f7m9.save

f7m10 = f7.major.new
f7m10.code = "MBTE"
I18n.locale = :en
f7m10.name = "Molecular Biotechnology" 
I18n.locale = :zh_HK
f7m10.name = "分子生物技術學"
f7m10.save

f7m11 = f7.major.new
f7m11.code = "PHYS"
I18n.locale = :en
f7m11.name = "Physics" 
I18n.locale = :zh_HK
f7m11.name = "物理"
f7m11.save

f7m12 = f7.major.new
f7m12.code = "STAT"
I18n.locale = :en
f7m12.name = "Statistics" 
I18n.locale = :zh_HK
f7m12.name = "統計學"
f7m12.save

f7m13 = f7.major.new
f7m13.code = "NSCI"
I18n.locale = :en
f7m13.name = "Natural Sciences" 
I18n.locale = :zh_HK
f7m13.name = "自然科學"
f7m13.save

f7m14 = f7.major.new
f7m14.code = "RMSC"
I18n.locale = :en
f7m14.name = "Risk Management Science" 
I18n.locale = :zh_HK
f7m14.name = "風險管理科學"
f7m14.save

f7.save

f8 = User::Faculty.new
f8.order = 9
I18n.locale = :en
f8.name = "Faculty of Social Science" 
I18n.locale = :zh_HK
f8.name = "社會科學院"

f8m1 = f8.major.new
f8m1.code = "BSSC"
I18n.locale = :en
f8m1.name = "Social Science(Broad-based Admission)" 
I18n.locale = :zh_HK
f8m1.name = "社會科學院(大類招生)"
f8m1.save

f8m2 = f8.major.new
f8m2.code = "ARCH"
I18n.locale = :en
f8m2.name = "Architectural Studies" 
I18n.locale = :zh_HK
f8m2.name = "建築學"
f8m2.save

f8m3 = f8.major.new
f8m3.code = "COMM"
I18n.locale = :en
f8m3.name = "Journalism and Communication" 
I18n.locale = :zh_HK
f8m3.name = "新聞與傳播學"
f8m3.save

f8m5 = f8.major.new
f8m5.code = "ECON"
I18n.locale = :en
f8m5.name = "Economics" 
I18n.locale = :zh_HK
f8m5.name = "經濟學"
f8m5.save

f8m6 = f8.major.new
f8m6.code = "GDRS"
I18n.locale = :en
f8m6.name = "Gender Studies" 
I18n.locale = :zh_HK
f8m6.name = "性別研究"
f8m6.save

f8m7 = f8.major.new
f8m7.code = "GLBS"
I18n.locale = :en
f8m7.name = "Global Studies" 
I18n.locale = :zh_HK
f8m7.name = "全球研究"
f8m7.save

f8m8 = f8.major.new
f8m8.code = "GPAD"
I18n.locale = :en
f8m8.name = "Government and Public Administration" 
I18n.locale = :zh_HK
f8m8.name = "政治與行政學"
f8m8.save

f8m9 = f8.major.new
f8m9.code = "GRMD"
I18n.locale = :en
f8m9.name = "Geography and Resource Management" 
I18n.locale = :zh_HK
f8m9.name = "地理與資源管理學"
f8m9.save

f8m10 = f8.major.new
f8m10.code = "PSYC"
I18n.locale = :en
f8m10.name = "Psychology" 
I18n.locale = :zh_HK
f8m10.name = "心理學"
f8m10.save

f8m11 = f8.major.new
f8m11.code = "SOCI"
I18n.locale = :en
f8m11.name = "Sociology" 
I18n.locale = :zh_HK
f8m11.name = "社會學"
f8m11.save

f8m12 = f8.major.new
f8m12.code = "SOWK"
I18n.locale = :en
f8m12.name = "Social Work" 
I18n.locale = :zh_HK
f8m12.name = "社會工作"
f8m12.save

f8m13 = f8.major.new
f8m13.code = "URSP"
I18n.locale = :en
f8m13.name = "Urban Studies" 
I18n.locale = :zh_HK
f8m13.name = "城市研究"
f8m13.save

f8.save

f9 = User::Faculty.new
f9.order = 10
I18n.locale = :en
f9.name = "Centre for China Studies" 
I18n.locale = :zh_HK
f9.name = "中國研究中心"

f9m1 = f9.major.new
f9m1.code = "CHES"
I18n.locale = :en
f9m1.name = "Chinese Studies" 
I18n.locale = :zh_HK
f9m1.name = "中國研究"
f9m1.save

f9m2 = f9.major.new
f9m2.code = "CCSS"
I18n.locale = :en
f9m2.name = "Contemporary China Studies" 
I18n.locale = :zh_HK
f9m2.name = "當代中國研究"
f9m2.save

f9.save

f10 = User::Faculty.new
f10.order = 11
I18n.locale = :en
f10.name = "Interdisciplinary Major Programme" 
I18n.locale = :zh_HK
f10.name = "跨學科主修課程"

f10m1 = f10.major.new
f10m1.code = "GLEF"
I18n.locale = :en
f10m1.name = "Global Economics and Finance" 
I18n.locale = :zh_HK
f10m1.name = "環球經濟與金融"
f10m1.save

f10m2 = f10.major.new
f10m2.code = "QFRM"
I18n.locale = :en
f10m2.name = "Quantitative Finance and Risk Management Science" 
I18n.locale = :zh_HK
f10m2.name = "計量金融學及風險管理科學"
f10m2.save

f10m3 = f10.major.new
f10m3.code = "QFRM"
I18n.locale = :en
f10m3.name = "MIEG - Mathematics and Information Engineering" 
I18n.locale = :zh_HK
f10m3.name = "數學與信息工程學"
f10m3.save

f10.save
