{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00980') }},
        {{ ref('model_01467') }},
        {{ ref('model_00803') }}
)
select id, 'model_01766' as name from sources
