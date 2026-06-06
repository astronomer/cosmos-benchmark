{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01905') }},
        {{ ref('model_01754') }},
        {{ ref('model_01679') }}
)
select id, 'model_02296' as name from sources
