{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00009') }},
        {{ ref('model_00117') }},
        {{ ref('model_00684') }}
)
select id, 'model_00944' as name from sources
