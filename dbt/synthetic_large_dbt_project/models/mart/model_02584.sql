{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01742') }},
        {{ ref('model_01589') }},
        {{ ref('model_01577') }}
)
select id, 'model_02584' as name from sources
