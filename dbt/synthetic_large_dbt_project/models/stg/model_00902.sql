{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00321') }},
        {{ ref('model_00012') }},
        {{ ref('model_00721') }}
)
select id, 'model_00902' as name from sources
