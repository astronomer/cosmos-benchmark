{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00206') }},
        {{ ref('model_00508') }}
)
select id, 'model_01418' as name from sources
