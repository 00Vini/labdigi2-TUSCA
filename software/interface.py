import serial
import tkinter as tk
from tkinter import messagebox
import threading
import time
import string

# Configurações da porta serial para envio
ser  = serial.Serial(
    port='COM30',        # Substitua pelo nome da sua porta
    baudrate=115200,      
    parity=serial.PARITY_ODD,  # Paridade
    stopbits=serial.STOPBITS_ONE, # Bits de parada
    bytesize=serial.EIGHTBITS,   # Bits de dados
    timeout=1           # Tempo limite de leitura
)


# Variável de controle para o loop de recebimento
receiving = True   # Sempre ativo enquanto o programa estiver rodando

#Recebe dados continuamente enquanto o programa estiver em execução
def receber_dados_continuamente():
    while receiving:
        try:
            # Lê 8 bytes de uma vez
            if ser.in_waiting > 0:
                data = ser.read(8)
                if len(data) == 8:
                    # Atualiza as labels com os dados combinados
                    byte1 = data[0]
                    byte2 = data[1]
                    byte3 = data[2]
                    byte4 = data[3]
                    byte5 = data[4]
                    byte6 = data[5]
                    byte7 = data[6]
                    byte8 = data[7]

                    # Converte os bytes para ASCII ou usa ponto (.) se não for exibível
                    char1 = chr(byte1) if chr(byte1) in string.printable else '.'
                    char2 = chr(byte2) if chr(byte2) in string.printable else '.'
                    char3 = chr(byte3) if chr(byte3) in string.printable else '.'
                    char4 = chr(byte4) if chr(byte4) in string.printable else '.'
                    char5 = chr(byte5) if chr(byte5) in string.printable else '.'
                    char6 = chr(byte6) if chr(byte6) in string.printable else '.'
                    char7 = chr(byte7) if chr(byte7) in string.printable else '.'
                    char8 = chr(byte8) if chr(byte8) in string.printable else '.'

                    # Atualiza as caixas com os dados recebidos
                    label_bytes1_2.config(text=f"{char1}{char2}.{char4}{char3}ºC")
                    label_bytes5_6.config(text=f"{char5}{char6}.{char7}{char8}%")
            time.sleep(0.1)
        except Exception as e:
            messagebox.showerror("Erro", f"Erro ao receber dados: {e}")
            break

#Envia dados serialmente
def enviar_dados():
    try:
        data = []
        numeric_data = []
        for i, entry in enumerate(entries_valores):
            valor = entry.get().strip()

            # Validar o formato do valor
            if not valor.replace('.', '', 1).isdigit() or valor.count('.') != 1:
                if i + 1 < 9:
                    raise ValueError(f"Temperatura {i+1} deve estar no formato 'WX.YZ' (quatro números com um ponto no meio)")
                else:
                    raise ValueError(f"Umidade deve estar no formato 'WX.YZ' (quatro números com um ponto no meio)")
            
            # Separar partes inteira e decimal
            partes = valor.split('.')
            dezena_unidade = int(partes[0])  
            decimos_centimos = int(partes[1])

            # Validar intervalo
            if dezena_unidade < 0 or dezena_unidade > 99 or decimos_centimos < 0 or decimos_centimos > 99:
                if i + 1 < 8:
                    raise ValueError(f"Temperatura {i+1} deve estar entre 0.00 e 99.99.")
                else:
                    raise ValueError(f"Umidade deve estar entre 0.00 e 99.99.")
            
            # Adicionar ao array de dados
            data.extend([decimos_centimos, dezena_unidade])
            numeric_data.append(dezena_unidade + decimos_centimos / 100)
            
        # Validando a ordem crescente
        if (numeric_data[:-1] != sorted(numeric_data[:-1])):
            raise ValueError("Os valores de temperatura devem ser inseridos em ordem crescente.")


        # Enviar todos os dados
        ser.write(bytes(data)) 
        messagebox.showinfo("Sucesso", f"Dados enviados: {data}")
    except ValueError as ve:
        messagebox.showerror("Erro", f"Valor inválido ({i+1}): {ve}")
    except Exception as e:
        messagebox.showerror("Erro", f"Erro ao enviar dados: {e}")

# Função para definir dados proporcionalmente
def definir_proporcional():
    min_value = float(entries_valores[0].get().strip())
    max_value = float(entries_valores[-1].get().strip())
    incremento = (max_value - min_value) / 7
    for i, entry in enumerate(entries_valores[1:-1]):
        entry.delete(0, tk.END)
        entry.insert(0, f"{min_value + (i+1)*incremento:05.2f}")
        

# Função para encerrar o programa
def encerrar_programa():
    """Fecha as portas seriais e encerra o programa."""
    global receiving
    receiving = False
    ser.close()
    root.destroy()


# Configurar a janela principal
root = tk.Tk()
root.title("Interface Serial")
root.geometry("800x700")  # Largura x Altura

# Seção de título "T.U.S.C.A" com borda
label_tusca = tk.Label(root, text="T.U.S.C.A\nTemperatura e Umidade: Sistema de Controle Automático", font=("Arial", 18, "bold"), anchor="center", 
                       bd=4, relief="ridge", padx=20, pady=10, bg="#ffc940")
label_tusca.pack(pady=10)

# Criar o frame para organizar a interface em duas colunas
frame = tk.Frame(root)
frame.pack(pady=10, padx=10)

# Configurar as duas colunas
frame.grid_columnconfigure(0, weight=1, uniform="equal", minsize=350)
frame.grid_columnconfigure(1, weight=1, minsize=10)
frame.grid_columnconfigure(2, weight=1, uniform="equal", minsize=350)

# Primeira coluna: Campos de entrada para valores e o botão de enviar, dentro de um frame com borda
frame_coluna1 = tk.Frame(frame, bd=4, relief="ridge", padx=10, pady=10, bg="#ffc940", )
frame_coluna1.grid(row=0, rowspan=15, column=0, padx=10, pady=5, sticky="nsew")
frame_coluna1.grid_columnconfigure(0, weight=1, uniform="equal")


descricoes = [
    "Temperatura 1 (ºC):", "Temperatura 2 (ºC):", "Temperatura 3 (ºC):", 
    "Temperatura 4 (ºC):", "Temperatura 5 (ºC):", "Temperatura 6 (ºC):",
    "Temperatura 7 (ºC):", "Umidade (%):"
]

tk.Label(frame_coluna1, text="Configuração de \ntemperatura e umidade", font=("Roboto", 17, "bold"), bg="#ffc940").grid(row=0, column=0, columnspan=10, padx=10, pady=5)

entries_valores = []  # Lista para armazenar os campos de entrada
for i, descricao in enumerate(descricoes):
    tk.Label(frame_coluna1, text=descricao, font=("Roboto", 12), anchor="w", bg="#ffc940", justify="center").grid(row=i+1, column=0, padx=10, pady=5, sticky="w")
    entry = tk.Entry(frame_coluna1, width=10, font=("Roboto", 14), bd=2, relief="sunken", justify="center")
    entry.grid(row=i+1, column=1, padx=10, pady=5)
    entry.insert(0, f"00.00")  # Valores padrão
    entries_valores.append(entry)

frame_botoes = tk.Frame(frame_coluna1, bg="#ffc940")
frame_botoes.grid(row=len(descricoes)+1, column=0, columnspan=2, pady=10)

btn_setar = tk.Button(frame_botoes, text="Preencher", command=definir_proporcional, font=("Roboto", 14), width=10, bd=4, relief="raised")
btn_setar.grid(row=0, column=0, padx=5)

btn_enviar = tk.Button(frame_botoes, text="Enviar Dados", command=enviar_dados, font=("Roboto", 14), width=20, bd=4, relief="raised", anchor="w")
btn_enviar.grid(row=0, column=1, padx=5)

# Coluna 2: Exibição de dados recebidos
frame_coluna2 = tk.Frame(frame, bd=4, relief="ridge", padx=10, pady=10, bg="#ffc940")
frame_coluna2.grid(row=0, column=2, padx=10, pady=5, sticky="nsew")
frame_coluna2.grid_columnconfigure(0, weight=1, uniform="equal")

tk.Label(frame_coluna2, text="Última medição", font=("Roboto", 17, "bold"), bg="#ffc940").grid(row=0, column=0,  padx=10, pady=5)

frame_recebidos = tk.Frame(frame_coluna2, bg="#ffc940")
frame_recebidos.grid(row=1, column=0, pady=10)

label_temp = tk.Label(frame_recebidos, text="Temperatura:", font=("Roboto", 14), width=12, anchor="center", bg="#ffc940", justify="center")
label_temp.grid(row=0, column=0, pady=5)

label_bytes1_2 = tk.Label(frame_recebidos, text="00.00 ºC", font=("Roboto", 20), width=12, anchor="center", padx=5, pady=5, bd=2, relief="sunken")
label_bytes1_2.grid(row=1, column=0, pady=5)

label_umidade = tk.Label(frame_recebidos, text="Umidade:", font=("Roboto", 14), width=12, anchor="center", bg="#ffc940")
label_umidade.grid(row=2, column=0, pady=5)

label_bytes5_6 = tk.Label(frame_recebidos, text="00.00%", font=("Roboto", 20), width=12, anchor="center", padx=5, pady=5, bd=2, relief="sunken")
label_bytes5_6.grid(row=3, column=0, pady=5)

btn_sair = tk.Button(root, text="Sair", command=encerrar_programa, font=("Roboto", 14), width=20, bg="red", fg="white")
btn_sair.pack(pady=10)

# Inicia o recebimento em uma thread separada
threading.Thread(target=receber_dados_continuamente, daemon=True).start()

# Iniciar o loop da interface gráfica
try:
    root.mainloop()
except KeyboardInterrupt:
    encerrar_programa()
