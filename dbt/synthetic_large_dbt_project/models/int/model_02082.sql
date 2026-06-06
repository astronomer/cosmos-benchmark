{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01180') }},
        {{ ref('model_00815') }}
)
select id, 'model_02082' as name from sources
