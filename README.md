# Asus Battery Health Charging for Linux.
we all know about Asus's Battery Health Charging feature [More Info Here](https://www.asus.com/us/support/FAQ/1032726/)</br>
In short it's stops charging current at a battery percent & Allows us to save our battery from overcharge & maintain battery health.
This is the Same thing using Linux kernel threshold :)

![Asus Battery Health Charging](https://i.ibb.co/tMhqkRS/Asus-Battery-Health-Charging.jpg)

### Requirements
* Linux Kernel 5.4 or above.
* Any linux destro.
* Some Brain.

### Installation & Update:
Open your terminal & run:

```bash
wget https://raw.githubusercontent.com/RahulPalXDA/asus_battery_health_charging/master/Health_Charging.sh && sudo mv Health_Charging.sh /usr/bin/Health_Charging && sudo chmod 777 /usr/bin/Health_Charging
```
### Usage:
just run `Health_Charging` in your terminal than you will get it by your own.


## More info
* [Arch linux Wiki page](https://wiki.archlinux.org/index.php/Laptop/ASUS#Battery_charge_threshold)
* [ASUS Battery Information Center](https://www.asus.com/support/FAQ/1038475/)

-----
>Tested in Asus x505za ( AMD Ryzen 2500U ) running arch linux , kernel: 5.10.84-1-lts
