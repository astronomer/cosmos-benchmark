{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01792') }},
        {{ ref('model_02183') }},
        {{ ref('model_01754') }}
)
select id, 'model_02652' as name from sources
