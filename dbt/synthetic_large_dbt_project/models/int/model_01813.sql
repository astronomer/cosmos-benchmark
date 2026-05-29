{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00760') }},
        {{ ref('model_01184') }}
)
select id, 'model_01813' as name from sources
