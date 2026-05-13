edad = int(input("ingrese su edad: "))

if edad < 13:
    print("niño")
elif edad < 18:
    print("adolescente")
else:
    print("adulto")

# while: repetir mientras se cumpla una condicion
contador = 5
while contador > 0:
    print(f"faltan {contador}...")
    contador -= 1
print("despegue!")

# for + range: repetir N veces
for i in range(10, 0, -1):
    print(f"iteracion {i}")