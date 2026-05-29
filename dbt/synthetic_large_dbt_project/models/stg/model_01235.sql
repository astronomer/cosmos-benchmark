{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00638') }},
        {{ ref('model_00184') }}
)
select id, 'model_01235' as name from sources
