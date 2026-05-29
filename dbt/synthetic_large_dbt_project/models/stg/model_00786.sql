{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00151') }},
        {{ ref('model_00093') }}
)
select id, 'model_00786' as name from sources
