with stg_dim_products as (
    select
        product_id as nk_product_id,
        name,
        subcategory_id as nk_subcategory_id,
        price,
        stock
    from {{ ref("stg_mini_order__product") }}
),

dim_subcategories as (
    select *
    from {{ ref("dim_subcategories") }}
),

final_dim_products as (
    select
        {{ dbt_utils.generate_surrogate_key( ["nk_product_id"] ) }} as sk_product_id,
        sdp.nk_product_id,
        sdp.name,
        dsc.sk_subcategory_id,
        sdp.price,
        sdp.stock,
        {{ dbt_date.now() }} as created_at,
        {{ dbt_date.now() }} as updated_at
    from stg_dim_products sdp
    join dim_subcategories dsc
        on dsc.nk_subcategory_id = sdp.nk_subcategory_id
)

select * from final_dim_products