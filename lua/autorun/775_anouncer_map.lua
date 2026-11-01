timer.Simple(0,function()
	Metrostroi.ANNOUNCER_MAP_775 = {
		[1]={
			name = "Замоскворецкая",
			fname = "Замоскворецкая",
			["2/6"] = false,
			loop = false,
			color = Color(45, 190, 44),
			pic = "2",
			stations = {
				[1] = {
					name = "Алма-Атинская",
					ename = "Alma-Atinskaya",
					right = {true,true},
					tr = {{p="g",s="Алма-Атинская",lc=Color(69,131,212)},{p="W",s="Алма-Атинская",lc=Color(69,131,212)},{p="I",s="Алма-Атинская",lc=Color(69,131,212)}},
					tre = {
						l = {t = 2,e = {
							{t = 1, e = "1"},
							{t = 3, e = "Братеевская улица"},
							{t = 2, e = "g",c=Color(69,131,212)},
							{t = 3, e = "автобус до автовокзала «Южные Ворота»"},
						}},
						c = false,
						r = {t = 1,e = {
							{t = 1, e = "2",c=Color(153,204,0)},
							{t = 3, e = "Ключевая улица, 24"},
						}}
					},
					snd = {
						{{"subway_announcers/asnp/zl_02_o_g.mp3", 14},{"subway_announcers/asnp/zl_01_p_g.mp3", 25}},
						{{"subway_announcers/asnp/zl_02_o_g.mp3", 14},{"subway_announcers/asnp/zl_01_p_g.mp3", 25}}
					}
				},
				[2] = {
					name = "Красногвардейская",
					ename = "Krasnogvardeyskaya",
					right = {true,true},
					tr = {{p="*",s="Зябликово",lc=Color(153,204,0)},{p="g",s="Красногвардейская",lc=Color(69,131,212)},{p="I",s="Домодедовская",lc=Color(69,131,212)}},
					tre = {
						l = {t = 2,e = {
							{t = 1, e = "1-4"},
							{t = 2, e = "g",c=Color(0,0,0)},
							{t = 3, e = "Автовокзал «Красногвардейский»"},
						}},
						c = {x = 50,t = 3,e = {
							{t = 2, e = "*",c=Color(177,255,10)},
							{t = 3, e = "Зябликово"},
						}},
						r = {t = 1,e = {
							{t = 1, e = "5-8",c=Color(153,204,0)},
							{t = 3, e = "Ореховый бульвар\n(к Елецкой улице)"},
						}}
					},
					snd = {
						{{"subway_announcers/asnp/zl_03_o_g.mp3", 8},{"subway_announcers/asnp/zl_02_p_g.mp3", 14}},
						{{"subway_announcers/asnp/zl_01_o_g.mp3", 8},{"subway_announcers/asnp/zl_02_p_g.mp3", 14}}
					}
				},
				[3] = {
					name = "Домодедовская",
					ename = "Domodedovskaya",
					right = {true,true},
					tr = {{p="g",s="Домодедовская",lc=Color(255,79,91)},{p="d",s="Домодедовская",lc=Color(255,79,91)},{p="!",s="Домодедовская",lc=Color(255,79,91)},{p="I",s="Домодедовская",lc=Color(69,131,212)}},
					tre = {
						l = {t = 1,e = {
							{t = 1, e = "1-3"},
							{t = 3, e = "Ореховый бульвар"},
						}},
						c = {x = 1250,t = 3,e = {
							{t = 2, e = "g d",c=Color(255,79,91)},
							{t = 3, e = "Экспресс-автобус\nв аэропорт Домодедово"},
						}},
						r = {t = 2,e = {
							{t = 1, e = "4-14",c=Color(153,204,0)},
							{t = 3, e = "Каширское шоссе"},
						}}
					},
					snd = {
						{{"subway_announcers/asnp/zl_04_o_g.mp3", 7},{"subway_announcers/asnp/zl_03_p_g.mp3", 16}},
						{{"subway_announcers/asnp/zl_02_o_g.mp3", 14},{"subway_announcers/asnp/zl_03_p_g.mp3", 16}}
					}
				},
				[4] = {
					name = "Орехово",
					ename = "Orekhovo",
					right = {true,true},
					tre = {
						l = {t = 1,e = {
							{t = 1, e = "1"},
							{t = 3, e = "Шипиловский Проезд"},
						}},
						c = false,
						r = {t = 1,e = {
							{t = 1, e = "2-3"},
							{t = 3, e = "Музей-заповедник «Царицыно»"},
						}}
					},
					snd = {
						{{"subway_announcers/asnp/zl_05_o_g.mp3", 7},{"subway_announcers/asnp/zl_04_p_g.mp3", 11}},
						{{"subway_announcers/asnp/zl_01_o_g.mp3", 8},{"subway_announcers/asnp/zl_04_p_g.mp3", 11}}
					}
				},
			},
		},
		[2]={
			name = "Калужско-Рижская",
			fname = "Калужско-Рижская",
			["2/6"] = false,
			loop = false,
			color = Color(237, 145, 33),
			pic = "6",
			stations = {
				[1] = {
					name = "Новые Черёмушки",
					ename = "Novye Cheryomushki",
					right = {true,true},
					tre = {
						l = {t = 1,e = {
							{t = 1, e = "1-4"},
							{t = 3, e = "Профсоюзная улица (к улице Намёткина)"},
						}},
						c = false,
						r = {t = 1,e = {
							{t = 1, e = "5-8"},
							{t = 3, e = "Профсоюзная улица (к Нахимовскому проспекту)"},
						}}
					},
					snd = {
						{{"subway_announcers/2020s/KRL_08_1_otpr.mp3", 12.53},nil},
						{nil,{"subway_announcers/2020s/KRL_07_2_prib.mp3", 26.16}}
					}
				},
				[2] = {
					name = "Профсоюзная",
					ename = "Profsoyuznaya",
					right = {true,true},
					tre = {
						l = {t = 1,e = {
							{t = 1, e = "1-4"},
							{t = 3, e = "Профсоюзная улица (к улице Гарибальди)"},
						}},
						c = false,
						r = {t = 1,e = {
							{t = 1, e = "5-8"},
							{t = 3, e = "Профсоюзная улица (к улице Кржижановского)"},
						}}
					},
					snd = {
						{{"subway_announcers/2020s/KRL_09_1_otpr.mp3", 16.43},{"subway_announcers/2020s/KRL_08_1_prib.mp3", 4.62}},
						{{"subway_announcers/2020s/KRL_07_2_otpr.mp3", 17.09},{"subway_announcers/2020s/KRL_08_2_prib.mp3", 5.35}}
					}
				},
				[3] = {
					name = "Академическая",
					ename = "Akademicheskaya",
					right = {true,true},
					tre = {
						l = {t = 1,e = {
							{t = 1, e = "1-4"},
							{t = 3, e = "Профсоюзная улица"},
						}},
						c = false,
						r = {t = 1,e = {
							{t = 1, e = "5-8"},
							{t = 3, e = "проспект 60-летия Октября"},
						}}
					},
					snd = {
						{{"subway_announcers/2020s/KRL_10_1_otpr.mp3", 13.30},{"subway_announcers/2020s/KRL_09_1_prib.mp3", 4.94}},
						{{"subway_announcers/2020s/KRL_08_2_otpr.mp3", 8.95},{"subway_announcers/2020s/KRL_09_2_prib.mp3", 5.64}}
					}
				},
				[4] = {
					name = "Ленинский проспект",
					ename = "Leninskiy Prospect",
					right = {true,true},
					tr = {{p="+",s="Площадь Гагарина",lc=Color(255,0,0)}},
					tre = {
						l = {t = 1,e = {
							{t = 1, e = "1-4"},
							{t = 3, e = "Профсоюзная улица (к улице Намёткина)"},
						}},
						c = false,
						r = {t = 1,e = {
							{t = 1, e = "5-8"},
							{t = 3, e = "Профсоюзная улица (к Нахимовскому проспекту)"},
						}}
					},
					snd = {
						{{"subway_announcers/2020s/KRL_11_1_otpr.mp3", 8.45},{"subway_announcers/2020s/KRL_10_1_prib.mp3", 14.83}},
						{{"subway_announcers/2020s/KRL_09_2_otpr.mp3", 16.62},{"subway_announcers/2020s/KRL_10_2_prib.mp3", 15.35}}
					}
				},
				[5] = {
					name = "Шаболовская",
					ename = "Shabolovskaya",
					right = {true,true},
					snd = {
						{{"subway_announcers/2020s/KRL_12_1_otpr.mp3", 8.52},{"subway_announcers/2020s/KRL_11_1_prib.mp3", 4.71}},
						{{"subway_announcers/2020s/KRL_10_2_otpr.mp3", 9.58},{"subway_announcers/2020s/KRL_11_2_prib.mp3", 5.16}}
					}
				},
				[6] = {
					name = "Октябрьская",
					ename = "Oktyabrskaya",
					right = {true,true},
					tr = {{p="5",s="Октябрьская",lc=Color(141, 91, 45)}},
					snd = {
						{nil,{"subway_announcers/2020s/KRL_12_1_prib.mp3", 28.36}},
						{{"subway_announcers/2020s/KRL_11_2_otpr.mp3", 8.73},nil}
					}
				},
			},
		},
		[3]={
			name = "Таганско-Краснопр.",
			fname = "Таганско-Краснопресненская",
			["2/6"] = false,
			loop = false,
			color = Color(128,0,128),
			pic = "7",
			stations = {
				[1] = {
					name = "Котельники",
					ename = "Kotelniki",
					right = {true,true},
					tre = {
						l = {t = 1,e = {
							{t = 1, e = "1-2"},
							{t = 3, e = 'Микрорайон "Опытное Поле'},
						}},
						c = false,
						r = {t = 1,e = {
							{t = 1, e = "3-7"},
							{t = 3, e = "Новорязанское шоссе"},
						}},
					},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
				[2] = {
					name = "Жулебино",
					ename = "Zhulebino",
					right = {true,true},
					tre = {
						l = {t = 1,e = {
							{t = 1, e = "1-7"},
							{t = 3, e = "Улица Генерала Кузнецова к Новорязанскому ш."},
						}},
						c = false,
						r = {t = 1,e = {
							{t = 1, e = "8-11"},
							{t = 3, e = "Улица Генерала Кузнецова к улице Кирова"},
						}},
					},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
				[3] = {
					name = "Лермонтовский пр.",
					fname = "Лермонтовский проспект",
					ename = "Lermontovsky Prospekt",
					right = {true,true},
					tr = {{p="&",s="Косино",lc=Color(222,100,161)},{p="t",s="Косино",lc=Color(212,82,37)}},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
				[4] = {
					name = "Выхино",
					ename = "Vykhino",
					right = {false,false},
					tr = {{p="t",s="Выхино",lc=Color(212,82,37)}},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
				[5] = {
					name = "Рязанский пр.",
					fname = "Рязанский проспект",
					ename = "Ryazansky Prospekt",
					right = {true,true},
					tr = {{p="t",s="Вешняки",lc=Color(212,82,37)}},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
				[6] = {
					name = "Кузьминки",
					ename = "Kuzminki",
					right = {true,true},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
				[7] = {
					name = "Текстильщики",
					ename = "Tekstilshchiki",
					right = {true,true},
					tr = {{p="(",s="Текстильщики",lc=Color(130,192,192)},{p="s",s="Текстильщики",lc=Color(231,66,128)}},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
				[8] = {
					name = "Волгоградский пр.",
					fname = "Волгоградский проспект",
					ename = "Volgogradsky Prospekt",
					right = {true,true},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
				[9] = {
					name = "Пролетарская",
					ename = "Proletarskaya",
					right = {true,true},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
			},
		},
		[4]={
			name = "Калининская",
			fname = "Калининская",
			["2/6"] = true,
			loop = false,
			color = Color(255,215,2),
			pic = "8",
			stations = {
				[1] = {
					name = "Новокосино",
					ename = "Novokosino",
					right = {true,true},
					tr = {{p="u",s="Реутов",lc=Color(72,169,124)}},
					tre = {
						l = {t = 1,e = {
							{t = 1, e = "1-2"},
							{t = 3, e = "Носовихинское шоссе\n(к Салтыковке)"},
						}},
						c = false,
						r = {t = 1,e = {
							{t = 1, e = "3-5"},
							{t = 3, e = "Носовихинское шоссе\n(к МКАД)"},
							{t = 2, e = "u",c=Color(72,169,124)},
							{t = 3, e = "Реутов"}
						}}
					},
					snd = {
						{{"subway_announcers/kalininskaya_real_717/otpr_02_m.mp3", 6.7},nil},
						{nil,{"subway_announcers/kalininskaya_real_717/prib_01_g.mp3", 13.19}}
					}
				},
				[2] = {
					name = "Новогиреево",
					ename = "Novogireevo",
					right = {true,true},
					tr = {{p="u",s="Новогиреево",lc=Color(72,169,124)},{p="G",s="Новогиреево",lc=Color(69,131,212)}},
					tre = {
						l = {t = 1,e = {
							{t = 1, e = "1-4"},
							{t = 3, e = "Зелёный проспект\n ко 2-му проспекту Новогиреево"},
						}},
						c = false,
						r = {t = 1,e = {
							{t = 1, e = "3-5"},
							{t = 3, e = "Зелёный проспект\n ко 5-му проспекту Новогиреево"},
							{t = 2, e = "G",c=Color(69,131,212)},
							{t = 3, e = "Автостанция «Новогиреево»"},
							{t = 2, e = "u",c=Color(72,169,124)},
							{t = 3, e = "Новогиреево"}
						}}
					},
					snd = {
						{{"subway_announcers/kalininskaya_real_717/otpr_03_m.mp3", 16.59},{"subway_announcers/kalininskaya_real_717/prib_02_m.mp3", 8.04}},
						{{"subway_announcers/kalininskaya_real_717/otpr_01_g.mp3", 6.22},{"subway_announcers/kalininskaya_real_717/prib_02_g.mp3", 7.42}}
					}
				},
				[3] = {
					name = "Перово",
					ename = "Perovo",
					right = {true,true},
					tre = {
						l = {t = 1,e = {
							{t = 1, e = "1-2"},
							{t = 3, e = "Зелёный проспект\nк Новогиреевской улице"},
						}},
						c = false,
						r = {t = 1,e = {
							{t = 1, e = "3-5"},
							{t = 3, e = "Зелёный проспект\nк 1-й и 2-й Владимирским улицам"},
						}}
					},
					snd = {
						{{"subway_announcers/kalininskaya_real_717/otpr_04_m.mp3", 7.33},{"subway_announcers/kalininskaya_real_717/prib_03_m.mp3", 2.85}},
						{{"subway_announcers/kalininskaya_real_717/otpr_02_g.mp3", 6.27},{"subway_announcers/kalininskaya_real_717/prib_03_g.mp3", 2.63}}
					}
				},
				[4] = {
					name = "Ш. Энтузиастов",
					fname = "Шоссе Энтузиастов",
					ename = "Shosse Entuziastov",
					right = {true,true},
					tr = {{p="+",s="Шоссе Энтузиастов",lc=Color(255,0,0)}},
					tre = {
						l = {t = 1,e = {
							{t = 1, e = "1-4"},
							{t = 3, e = "Шоссе Энтузиастов"},
							{t = 2, e = "+",c=Color(255,0,0)},
							{t = 3, e = "Шоссе Энтузиастов"},
						}},
						c = false,
						r = false
					},
					snd = {
						{{"subway_announcers/kalininskaya_real_717/otpr_05_m.mp3", 17.13},{"subway_announcers/kalininskaya_real_717/prib_04_m.mp3", 3.89}},
						{{"subway_announcers/kalininskaya_real_717/otpr_03_g.mp3", 16.12},{"subway_announcers/kalininskaya_real_717/prib_04_g.mp3", 3.41}}
					}
				},
				[5] = {
					name = "Авиамоторная",
					ename = "Aviamotornaya",
					right = {true,true},
					tr = {{p="(",s="Авиамоторная",lc=Color(130,192,192)},{p="t",s="Авиамоторная",lc=Color(212,82,37)}},
					tre = {
						l = {t = 1,e = {
							{t = 1, e = "1-9"},
							{t = 3, e = "Авиамоторная улица"},
							{t = 2, e = "(",c=Color(130,192,192)},
							{t = 3, e = "Авиамоторная"},
							{t = 2, e = "t",c=Color(212,82,37)},
							{t = 3, e = "Авиамоторная"},
						}},
						c = false,
						r = false
					},
					snd = {
						{{"subway_announcers/kalininskaya_real_717/otpr_06_m.mp3", 7.1},{"subway_announcers/kalininskaya_real_717/prib_05_m.mp3", 3.49}},
						{{"subway_announcers/kalininskaya_real_717/otpr_04_g.mp3", 17.02},{"subway_announcers/kalininskaya_real_717/prib_05_g.mp3", 3.15}}
					}
				},
				[6] = {
					name = "Пл. Ильича",
					fname = "Площадь Ильича",
					ename = "Ploschad Ilyicha",
					right = {true,true},
					tr = {{p="*",s="Римская",lc=Color(153,204,0)},{p="s",s="Москва-Товарная",lc=Color(231,66,128)},{p="u",s="Серп и Молот",lc=Color(72,169,124)}},
					tre = {
						l = {t = 1,e = {
							{t = 1, e = "1-4"},
							{t = 3, e = "улица Сергея Радонежского"},
							{t = 2, e = "s",c=Color(231,66,128)},
							{t = 3, e = "Москва-Товарная"},
							{t = 2, e = "u",c=Color(72,169,124)},
							{t = 3, e = "Серп и Молот"},
						}},
						c = false,
						r = {t = 1,e = {
							{t = 2, e = "*",c=Color(153,204,0)},
							{t = 3, e = "Римская"},
						}}
					},
					snd = {
						{{"subway_announcers/kalininskaya_real_717/otpr_07_m.mp3", 6.38},{"subway_announcers/kalininskaya_real_717/prib_06_m.mp3", 12.25}},
						{{"subway_announcers/kalininskaya_real_717/otpr_05_g.mp3", 6.41},{"subway_announcers/kalininskaya_real_717/prib_06_g.mp3", 5.58}}
					}
				},
				[7] = {
					name = "Марксистская",
					ename = "Marksistskaya",
					right = {true,true},
					tr = {{p="5",s="Таганская",lc=Color(141,91,45)},{p="7",s="Таганская",lc=Color(128,0,128)}},
					tre = {
						l = {t = 2,e = {
							{t = 1, e = "5-6"},
							{t = 3, e = "Марксистская улица"},
						}},
						c = {x = 800,t = 1,e = {
							{t = 2, e = "7",c=Color(128,0,128)},
							{t = 3, e = "Таганская"},
						}},
						r = {t = 1,e = {
							{t = 2, e = "5",c=Color(141,91,45)},
							{t = 3, e = "Таганская"},
						}}
					},
					snd = {
						{{"subway_announcers/kalininskaya_real_717/otpr_08_m.mp3", 6.67},{"subway_announcers/kalininskaya_real_717/prib_07_m.mp3", 13.19}},
						{{"subway_announcers/kalininskaya_real_717/otpr_06_g.mp3", 6.58},{"subway_announcers/kalininskaya_real_717/prib_07_g.mp3", 12.52}}
					}
				},
				[8] = {
					name = "Третьяковская",
					ename = "Tretyakovskaya",
					right = {true,false},
					tr = {{p="2",s="Новокузнецкая",lc=Color(45,190,44)},{p="6",s="Третьяковская",lc=Color(237,145,33)}},
					tre = {
						l = {t = 1,e = {
							{t = 2, e = "2",c=Color(45,190,44)},
							{t = 3, e = "Новокузнецкая"},
						}},
						c = {x = 650,t = 3,e = {
							{t = 3, e = "Третьяковская\nдо Медведково"},
							{t = 2, e = "6",c=Color(237,145,33)},
							{t = 5},
							{t = 2, e = "8",c=Color(255,215,2)},
							{t = 3, e = "Третьяковская\nдо Новокосино"},
						}},
						c2 = {x = -250,t = 0,e = {
							{t = 4, e = "↖"},
							{t = 2, e = "6",c=Color(237,145,33)},
							{t = 3, e = "Третьяковская\nдо Новоясеневской"},
						}},
						c3 = {x = 1200,t = 0,e = {
							{t = 4, e = "↗"},
							{t = 2, e = "6",c=Color(237,145,33)},
							{t = 3, e = "Третьяковская\nдо Новоясеневской"},
						}},
						r = {t = 1,e = {
							{t = 1, e = "2"},
							{t = 3, e = "улица Большая Ордынка"},
						}}
					},
					snd = {
						{nil,{"subway_announcers/kalininskaya_real_717/prib_08_m.mp3", 18.61}},
						{{"subway_announcers/kalininskaya_real_717/otpr_07_g.mp3", 6.23},nil}
					}
				},
			}
		},
		[5]={
			name = "Люблинско-Дмитр.",
			fname = "Люблинско-Дмитровская",
			["2/6"] = false,
			loop = false,
			color = Color(153,204,0),
			pic = "*",
			stations = {
				[1] = {
					name = "Люблино",
					ename = "Lyublino",
					right = {true,true},
					tre = {
						l = {t = 1,e = {
							{t = 1, e = "1"},
							{t = 3, e = "Совхозная улица в Марьино"},
						}},
						c = false,
						r = {t = 1,e = {
							{t = 1, e = "2-6"},
							{t = 3, e = "Краснодрская улица"},
						}},
					},
					snd = {
						{{"subway_announcers/ru_alterr/station/ldl_17_o_m.mp3",16},nil},
						{nil,{"subway_announcers/ru_alterr/station/ldl_18_p_g.mp3",22}}
					}
				},
				[2] = {
					name = "Волжская",
					ename = "Volzhskaya",
					right = {true,true},
					tre = {
						l = {t = 1,e = {
							{t = 1, e = "1-2"},
							{t = 3, e = "Краснодарская улица"},
						}},
						c = false,
						r = {t = 1,e = {
							{t = 1, e = "3-4"},
							{t = 3, e = "Парк им. Шкулёва"},
						}},
					},
					snd = {
						{{"subway_announcers/ru_alterr/station/ldl_16_o_m.mp3",12},{"subway_announcers/ru_alterr/station/ldl_17_p_m.mp3",8}},
						{{"subway_announcers/ru_alterr/station/ldl_18_o_g.mp3",16},{"subway_announcers/ru_alterr/station/ldl_17_p_g.mp3",8}}
					}
				},
				[3] = {
					name = "Печатники",
					ename = "Pechatniki",
					right = {true,true},
					tr = {{p="s",s="Кубанская",lc=Color(231,66,128)}},
					tre = {
						l = {t = 1,e = {
							{t = 1, e = "1-5"},
							{t = 3, e = "Шоссейная улица"},
							{t = 2, e = "s", c=Color(231,66,128)},
							{t = 3, e = "Кубанская"}
						}},
						c = false,
						r = false,
					},
					snd = {
						{{"subway_announcers/ru_alterr/station/ldl_15_o_m.mp3",16},{"subway_announcers/ru_alterr/station/ldl_16_p_m.mp3",16}},
						{{"subway_announcers/ru_alterr/station/ldl_17_o_g.mp3",12},{"subway_announcers/ru_alterr/station/ldl_16_p_g.mp3",14}}
					}
				},
				[4] = {
					name = "Кожуховская",
					ename = "Kozhukhovckaya",
					right = {true,true},
					tr = {{p="+",s="Дубровка",lc=Color(255,0,0)}},
					tre = {
						l = {t = 1,e = {
							{t = 1, e = "1-2"},
							{t = 3, e = "Южнопортовая улица"},
							{t = 2, e = "+", c=Color(255,0,0)},
							{t = 3, e = "Дубровка"}
						}},
						c = false,
						r = false,
					},
					snd = {
						{{"subway_announcers/ru_alterr/station/ldl_14_o_m.mp3",8},{"subway_announcers/ru_alterr/station/ldl_15_p_m.mp3",19}},
						{{"subway_announcers/ru_alterr/station/ldl_16_o_g.mp3",12},{"subway_announcers/ru_alterr/station/ldl_15_p_g.mp3",17}}
					}
				},
				[5] = {
					name = "Дубровка",
					ename = "Dubrovka",
					tr = {{p="+",s="Дубровка",lc=Color(255,0,0)}},
					tre = {
						l = {t = 1,e = {
							{t = 1, e = "1-3"},
							{t = 3, e = "Шарикоподшипниковская улица"},
							{t = 2, e = "+", c=Color(255,0,0)},
							{t = 3, e = "Дубровка"}
						}},
						c = false,
						r = false,
					},
					right = {true,true},
					snd = {
						{nil,{"subway_announcers/ru_alterr/station/ldl_14_p_m.mp3",30}},
						{{"subway_announcers/ru_alterr/station/ldl_15_o_g.mp3",16},nil}
					}
				},
			},
		},
		[6]={
			name = "Некрасовская",
			fname = "Некрасовская",
			["2/6"] = true,
			loop = false,
			color = Color(222,100,161),
			pic = "&",
			stations = {
				[1] = {
					name = "Некрасовка",
					ename = "Nekrasovka",
					right = {true,true},
					tre = {
						l = {t = 1,e = {
							{t = 1, e = "1-4"},
							{t = 3, e = "Рождественская улица, 33"},
						}},
						c = false,
						r = {t = 2,e = {
							{t = 1, e = "5-11"},
							{t = 3, e = "Просп. Защитников Москвы"},
						}}
					},
					snd = {
						{{"inf_NekrasovskayaLineV6/1_next_luhmanovskai.mp3", 9},nil},
						{nil,{"inf_NekrasovskayaLineV6/2_nekrasovka.mp3", 20}}
					}
				},
				[2] = {
					name = "Лухмановская",
					ename = "Lukhmanovskaya",
					right = {true,true},
					tre = {
						l = {t = 1,e = {
							{t = 1, e = "1"},
							{t = 3, e = "ул. 8 Марта"},
						}},
						c = false,
						r = {t = 1,e = {
							{t = 1, e = "2-4"},
							{t = 3, e = "Лухмановская ул."},
						}}
					},
					snd = {
						{{"inf_NekrasovskayaLineV6/1_next_yldmintievskogo.mp3",13},{"inf_NekrasovskayaLineV6/1_luhmanovskai.mp3",3}},
						{{"inf_NekrasovskayaLineV6/2_nex_nekrasovka.mp3",9},{"inf_NekrasovskayaLineV6/2_lyhmanovskai.mp3",2}}
					}
				},
				[3] = {
					name = "Ул. Дмитриевского",
					fname = "Улица Дмитриевского",
					ename = "Ulitsa Dmitrievskogo",
					right = {true,true},
					tre = {
						l = {t = 2,e = {
							{t = 1, e = "1-3"},
							{t = 3, e = "Салтыковская улица"},
						}},
						c = false,
						r = false,
					},
					snd = {
						{{"inf_NekrasovskayaLineV6/1_next_kosino.mp3",5},{"inf_NekrasovskayaLineV6/1_yldmintievskogo.mp3",2}},
						{{"inf_NekrasovskayaLineV6/2_nex_luhmanovskai.mp3",9},{"inf_NekrasovskayaLineV6/2_yldmintievskogo.mp3",2}}
					}
				},
				[4] = {
					name = "Косино",
					ename = "Kosino",
					right = {true,true},
					tr = {{p="7",s="Лермонтовский пр-кт",lc=Color(128,0,128)},{p="t",s="Косино",lc=Color(212,82,37)}},
					tre = {
						l = {t = 1,e = {
							{t = 1, e = "7"},
							{t = 3, e = "платформа Косино"},
						}},
						c = {x = 1400,t = 3,e = {
							{t = 2, e = "7",c=Color(128,0,128)},
							{t = 3, e = "Лермонтовский пр-кт"},
							{t = 5},
							{t = 1, e = "5-6"},
							{t = 3, e = "Лермонтовский пр-кт"},
						}},
					},
					snd = {
						{{"inf_NekrasovskayaLineV6/1_next_ugo-vostochnai.mp3",7},{"inf_NekrasovskayaLineV6/1_kosino.mp3",6}},
						{{"inf_NekrasovskayaLineV6/2_nex_yldmintievskogo.mp3",13},{"inf_NekrasovskayaLineV6/2_kosino.mp3",7}}
					}
				},
				[5] = {
					name = "Юго-Восточная",
					ename = "Yugo-Vostochnaya",
					right = {false,false},
					tre = {
						r = {t = 1,e = {
							{t = 1, e = "1-4"},
							{t = 3, e = "Ферганская улица"},
						}},
					},
					snd = {
						{{"inf_NekrasovskayaLineV6/1_next_okskai.mp3",10},{"inf_NekrasovskayaLineV6/1_ygo-vostochnai.mp3",4}},
						{{"inf_NekrasovskayaLineV6/2_nex_kosino.mp3",4},{"inf_NekrasovskayaLineV6/2_ugo-vostochnai.mp3",4}}
					}
				},
				[6] = {
					name = "Окская",
					ename = "Okskaya",
					right = {false,false},
					tre = {
						r = {t = 1,e = {
							{t = 1, e = "1-4"},
							{t = 3, e = "Рязанский проспект"},
						}},
					},
					snd = {
						{{"inf_NekrasovskayaLineV6/1_next_stahanovskai.mp3",6},{"inf_NekrasovskayaLineV6/1_okskai.mp3",3}},
						{{"inf_NekrasovskayaLineV6/2_nex_ugo-vostochnai.mp3",7},{"inf_NekrasovskayaLineV6/2_okskai.mp3",3}}
					}
				},
				[7] = {
					name = "Стахановская",
					ename = "Stakhanovskaya",
					right = {false,false},
					tre = {
						r = {t = 1,e = {
							{t = 1, e = "1-2"},
							{t = 3, e = "Рязанский проспект"},
						}},
					},
					snd = {
						{{"inf_NekrasovskayaLineV6/1_next_nejigorotskai.mp3",11},{"inf_NekrasovskayaLineV6/1_stahanovskai.mp3",3}},
						{{"inf_NekrasovskayaLineV6/2_nex_okskai.mp3",13},{"inf_NekrasovskayaLineV6/2_stahanovskai.mp3",4}}
					}
				},
				[8] = {
					name = "Нижегородская",
					ename = "Nizhegorodskaya",
					tr = {{p="(",s="Нижегородская",lc=Color(130,192,192)},{p="+",s="Нижегородская",lc=Color(256,0,0)},{p="u",s="Нижегородская",lc=Color(72,169,124)}},
					right = {false,false},
					tre = {
						l = {t = 1,e = {
							{t = 2, e = "(",c=Color(130,192,192)},
							{t = 3, e = "БКЛ (По часовой)"},
						}},
						c = {x = 800,t = 3,e = {
							{t = 3, e = "БКЛ (Против часовой)"},
							{t = 2, e = "(",c=Color(130,192,192)},
							{t = 5},
						}},
						r = {t = 1,e = {
							{t = 1, e = "1-7"},
							{t = 3, e = 'ТПУ"Нижегородская"'},
						    {t = 2, e = "+",c=Color(255,0,0)},
							{t = 3, e = "Нижегородская"},

						}}
					},
					snd = {
						{nil,{"inf_NekrasovskayaLineV6/1_nejigorostkai.mp3",27}},
						{{"inf_NekrasovskayaLineV6/2_nex_stahanovskai.mp3",7},nil}
					}
				},
			},
		},
		[7]={
			name = "Обкатка",
			fname = "Обкатка",
			["2/6"] = false,
			loop = false,
			color = Color(0,0,0),
			pic = "",
			stations = {
				[1] = {
					name = "Обкатка",
					right = {false,false},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
				[2] = {
					name = "Обкатка",
					right = {false,false},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
				[3] = {
					name = "Обкатка",
					right = {false,false},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
				[4] = {
					name = "Обкатка",
					right = {false,false},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
				[5] = {
					name = "Обкатка",
					right = {false,false},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
				[6] = {
					name = "Обкатка",
					right = {false,false},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
				[7] = {
					name = "Обкатка",
					right = {false,false},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
				[8] = {
					name = "Обкатка",
					right = {false,false},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
				[9] = {
					name = "Обкатка",
					right = {false,false},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
				[10] = {
					name = "Обкатка",
					right = {false,false},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
				[11] = {
					name = "Обкатка",
					right = {false,false},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				}
			},

		},
		[8]={
			name = "Перегонка",
			fname = "Перегонка",
			["2/6"] = false,
			loop = false,
			color = Color(0,0,0),
			pic = "",
			stations = {
				[1] = {
					name = "Перегонка",
					right = {false,false},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
				[2] = {
					name = "Перегонка",
					right = {false,false},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
				[3] = {
					name = "Перегонка",
					right = {false,false},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				}
			},
		},
		[9]={
			name = "В депо",
			fname = "В депо",
			loop = false,
			["2/6"] = false,
			color = Color(0,0,0),
			pic = "",
			stations = {
				[1] = {
					name = "В депо",
					right = {false,false},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
				[2] = {
					name = "В депо",
					right = {false,false},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
				[3] = {
					name = "В депо",
					right = {false,false},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				}
			},
		},
		[10]={
			name = ".",
			fname = ".",
			["2/6"] = false,
			loop = false,
			color = Color(0, 0, 0),
			stations = {
				[1] = {
					name = "In progress...",
					right = {false,false},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
			},
		},
		[11]={
			name = ".",
			fname = ".",
			["2/6"] = false,
			loop = false,
			color = Color(0, 0, 0),
			stations = {
				[1] = {
					name = "In progress...",
					right = {false,false},
					snd = {
						{nil,nil},
						{nil,nil}
					}
				},
			},
		},

		["Sounds"] = {
			click1 = {"subway_announcers/kalininskaya_real_717/click.mp3", 0.2},
			announcer_ready = {"subway_announcers/kalininskaya_real_717/announcer_ready.mp3", 3.87},
			spec_attention_train_depart = {"subway_announcers/kalininskaya_real_717/spec_attention_train_depart.mp3", 5.16},
			spec_attention_train_stop = {"subway_announcers/kalininskaya_real_717/spec_attention_train_stop.mp3", 4.7},
			spec_attention_train_fast = {"subway_announcers/kalininskaya_real_717/spec_attention_train_fast.mp3", 4.37},

			maska_perchatki_g = {"subway_announcers/kalininskaya_real_717/maska_perchatki_g.mp3", 5.2},
			maska_perchatki_m = {"subway_announcers/kalininskaya_real_717/maska_perchatki_m.mp3", 5.65},
			tone = {"subway_announcers/upo/rhino/crossline/tone.mp3", 1.2},
		},
	}
end)
