{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00941') }},
        {{ ref('model_01023') }}
)
select id, 'model_02017' as name from sources
