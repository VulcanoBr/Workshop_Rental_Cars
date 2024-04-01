
def login(usuario)

    click_on 'Log in'
    
        fill_in 'Email', with: usuario.email
        fill_in 'Senha', with: usuario.password
        click_on 'Log in'
    

end