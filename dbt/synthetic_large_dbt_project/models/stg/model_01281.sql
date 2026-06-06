{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00057') }},
        {{ ref('model_00345') }}
)
select id, 'model_01281' as name from sources
