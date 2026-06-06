{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00898') }},
        {{ ref('model_01081') }},
        {{ ref('model_01430') }}
)
select id, 'model_01943' as name from sources
