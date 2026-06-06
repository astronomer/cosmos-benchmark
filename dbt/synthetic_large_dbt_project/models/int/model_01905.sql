{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00829') }},
        {{ ref('model_01459') }},
        {{ ref('model_01229') }}
)
select id, 'model_01905' as name from sources
